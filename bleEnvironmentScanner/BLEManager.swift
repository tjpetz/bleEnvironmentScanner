//
//  BLEPeripheral.swift
//  bleEnvironmentScanner
//
//  Created by Thomas Petz, Jr. on 10/15/20.
//

import Foundation
import CoreBluetooth

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate {

    var centralManager: CBCentralManager!
    @Published var peripherals: [Peripheral] = []
    @Published var isScanning: Bool = false
    
    func findPeripheral(peripheral: CBPeripheral) -> Peripheral? {
        for p in peripherals {
            if p.rawPeripheral.identifier == peripheral.identifier {
                return p
            }
        }
        return nil
    }

    func findPeripheral(uuid: CBUUID) -> Peripheral? {
        for p in peripherals {
            if p.uuid == uuid {
                return p
            }
        }
        return nil
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Central started")
            scan()
        case .poweredOff:
            stopScanning()
            for p in peripherals {
                if p.isConnected {
                    p.disconnect()
                }
            }
        default:
            print("Central not in expected state")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Found \(peripheral.identifier.uuidString) with rssi = \(RSSI.intValue)")
        if let p = findPeripheral(peripheral: peripheral) {
            p.updateWithScanResults(scanRSSI: RSSI.intValue, advertisementData: advertisementData)
            if p.isConnectable && peripheral.state == .disconnected {
                centralManager.connect(peripheral)
            }
        } else {
            peripherals.append(Peripheral(peripheral, scanRSSI: RSSI.intValue, advertisementData: advertisementData, bleManager: self))
            if let isConnectable = advertisementData[CBAdvertisementDataIsConnectable] {
                if isConnectable as! Bool {
                    if peripheral.state == .disconnected {
                        centralManager.connect(peripheral)
                    }
                }
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.identifier.uuidString) with local name \(peripheral.name ?? "Unknown")")
        if let p = findPeripheral(peripheral: peripheral) {
            p.rawPeripheral.delegate = p
            p.uuid = CBUUID(nsuuid: peripheral.identifier)
            p.isConnected = true
            if let localName = peripheral.name {
                p.localName = localName
            }
            p.discoverServices()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to \(peripheral.identifier.uuidString) because \(error!.localizedDescription)")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnecting from \(peripheral.identifier.uuidString)")
        if let p = findPeripheral(peripheral: peripheral) {
            p.isConnected = false
        }
    }
    
    func scan() {
        isScanning = true
        centralManager.scanForPeripherals(
            withServices: nil, // [EnvironmentServiceView.serviceUUID],
            options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
        // stop scanning after 30 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
            self.stopScanning()
        }
    }

    func stopScanning() {
        isScanning = false
        centralManager.stopScan()
    }
    
    override init() {
        super.init()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
}
