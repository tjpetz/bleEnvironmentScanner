//
//  Peripheral.swift
//  bleEnvironmentScanner
//
//  Created by Thomas Petz, Jr. on 10/15/20.
//

import Foundation
import CoreBluetooth

class Peripheral: NSObject, ObservableObject, Identifiable, CBPeripheralDelegate {
    
    let rawPeripheral: CBPeripheral
    var advertisementData: [String : Any]?
    var bleManager: BLEManager
    
    @Published var uuid: CBUUID
    @Published var localName: String?
    @Published var rssi: Int
    @Published var txPower: Int?
    @Published var isConnected: Bool
    @Published var isConnectable: Bool
    
    @Published var services: [Service] = []
    
    func printCurrentState() {
        print("Peripheral.uuid = \(uuid)")
        print("Peripheral.localName = \(localName ?? "Not Available")")
        print("Peripheral.rssi = \(rssi)")
        print("Peripheral.txPower = \(txPower ?? -255)")
        print("Peripheral.isConnectable = \(isConnectable)")
        print("Peripheral.services count = \(services.count)")
    }
    
    // MARK: - Service Discovery
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("Discovered \(peripheral.services!.count) service(s) for \(peripheral.identifier.uuidString)")
        if let err = error {
            print("Error in discovery: \(err.localizedDescription)")
        }
        
        for service in peripheral.services! {
            print("Found service \(service.uuid)")
            if findService(service: service) == nil {       // only add if we've don't already have this service
                services.append(Service(peripheral: self, service: service))
            }
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func discoverServices() {
        rawPeripheral.delegate = self
        uuid = CBUUID(nsuuid: rawPeripheral.identifier)
        localName = rawPeripheral.name ?? ""
        rawPeripheral.discoverServices(nil)
    }

    func findService(service: CBService) -> Service? {
        for s in services {
            if service.uuid == s.uuid {
                return s
            }
        }
        return nil
    }
        
    // MARK: Characteristic discovery and processing
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("Found \(service.characteristics!.count) characteristic(s) for \(service.uuid.uuidString)")
        
        if let s = findService(service: service) {
            for c in service.characteristics! {
                print("Characteristic \(c.uuid)")
                if s.getCharacteristic(cbuuid: c.uuid) == nil {
                    // We haven't seen this characteristic before so add it to our list
                    s.characteristics.append(Characteristic(service: s, characteristic: c))
                }
                if c.properties.contains(.read) {
                    peripheral.readValue(for: c)
                }
            }
        } else {
            print("Unknown service !!!!!")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("Received update for \(characteristic.uuid.uuidString) of \(peripheral.identifier.uuidString) of \(String(describing: characteristic.value))")
        
        for s in services {
            for c in s.characteristics {
                if c.characteristic.uuid == characteristic.uuid {
                    c.value = characteristic.value
                    return
                }
            }
        }
    }

    func updateWithScanResults(scanRSSI rssi: Int, advertisementData: [String : Any])
    {
        self.rssi = rssi
        self.advertisementData = advertisementData
        if let localName = advertisementData[CBAdvertisementDataLocalNameKey] {
            self.localName = localName as? String
        }
        if let txPower = advertisementData[CBAdvertisementDataTxPowerLevelKey] {
            self.txPower = txPower as? Int
        }
        if let isConnectable = advertisementData[CBAdvertisementDataIsConnectable] {
            // Force to true if we receive a connectable.  Not every advertising packet will be connectable.
            // So the only time this should be false is if the peripheral is never connectable.
            if isConnectable as! Bool == true {
                self.isConnectable = true
            }
        } else {
            self.isConnectable = false
        }
        print("Scan updated settings")
        printCurrentState()
    }
    
    func connect() {
        bleManager.centralManager.connect(rawPeripheral)
    }
    
    func disconnect() {
        bleManager.centralManager.cancelPeripheralConnection(rawPeripheral)
    }
    
    // MARK: Constructors
    init(_ peripheral: CBPeripheral, bleManager: BLEManager) {
        rawPeripheral = peripheral
        uuid = CBUUID(nsuuid: peripheral.identifier)
        rssi = -90
        isConnectable = false
        self.bleManager = bleManager
        self.isConnected = false
        super.init()
    }
    
    init(_ peripheral: CBPeripheral, scanRSSI rssi: Int, advertisementData: [String : Any], bleManager: BLEManager) {
        rawPeripheral = peripheral
        uuid = CBUUID(nsuuid: peripheral.identifier)
        self.rssi = rssi
        self.advertisementData = advertisementData
        if let localName = advertisementData[CBAdvertisementDataLocalNameKey] {
            self.localName = localName as? String
        }
        if let txPower = advertisementData[CBAdvertisementDataTxPowerLevelKey] {
            self.txPower = txPower as? Int
        }
        if let isConnectable = advertisementData[CBAdvertisementDataIsConnectable] {
            self.isConnectable = isConnectable as! Bool
        } else {
            self.isConnectable = false
        }
        self.bleManager = bleManager
        self.isConnected = false
        super.init()
        print("Peripheral initialization")
        printCurrentState()
    }
}
