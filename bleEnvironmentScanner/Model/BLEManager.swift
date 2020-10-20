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
            centralManager!.stopScan()
        default:
            print("Central not in expected state")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Found \(peripheral.identifier.uuidString) with rssi = \(RSSI.intValue)")
        if let p = findPeripheral(peripheral: peripheral) {
            p.rssi = RSSI.intValue
            print("Updating RSSI")
        } else {
            peripherals.append(Peripheral(peripheral, scanRSSI: RSSI.intValue))
            centralManager.connect(peripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.identifier.uuidString)")
        if let p = findPeripheral(peripheral: peripheral) {
            p.uuid = CBUUID(nsuuid: peripheral.identifier)
            p.localName = peripheral.name
            p.discoverServices()
        }
    }
    
    func scan() {
        isScanning = true
        centralManager.scanForPeripherals(
            withServices: [EnvironmentService.environmentServiceCBUUID],
            options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
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
