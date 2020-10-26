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
    @Published var uuid: CBUUID
    @Published var localName: String?
    @Published var rssi: Int
    @Published var txPower: Int?

    @Published var services: [Service] = []
    
    // MARK: - Service Discovery
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("Discovered \(peripheral.services!.count) service(s) for \(peripheral.identifier.uuidString)")
        
        for service in peripheral.services! {
            print("Found service \(service.uuid)")
            services.append(Service(peripheral: self, service: service))
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
                s.characteristics.append(Characteristic(service: s, characteristic: c))
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
                if c.characteristic == characteristic {
                    c.value = characteristic.value
                    return
                }
            }
        }
    }

    // MARK: Constructors
    init(_ peripheral: CBPeripheral) {
        rawPeripheral = peripheral
        uuid = CBUUID(nsuuid: peripheral.identifier)
        rssi = -90
    }
    
    init(_ peripheral: CBPeripheral, scanRSSI rssi: Int, advertisementData: [String : Any]) {
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
    }
}
