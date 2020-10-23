//
//  BatteryService.swift
//  bleEnvironmentScanner
//
//  Created by Thomas Petz, Jr. on 10/15/20.
//

import Foundation
import CoreBluetooth

class BatteryService: NSObject, ObservableObject, CBPeripheralDelegate {
    
    static let batteryServiceCBUUID = CBUUID(string: "180F")
    static let batteryLevelCharacteristicCBUUID = CBUUID(string: "2A19")
    
    @Published var peripheral: Peripheral
    var rawService: CBService?
    var batteryLevelCharacteristic: CBCharacteristic? = nil
    
    @Published var batteryLevelPercent: UInt8 = 0
    
    func discoverCharacteristics() {
        peripheral.rawPeripheral.delegate = self
        peripheral.rawPeripheral.discoverCharacteristics(nil, for: rawService!)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("Found \(service.characteristics!.count) characteristic(s) for \(service.uuid.uuidString)")
        for c in service.characteristics! {
            print("Characteristic \(c.uuid)")
            switch c.uuid {
            case BatteryService.batteryLevelCharacteristicCBUUID:
                batteryLevelCharacteristic = c
            default:
                print("Unknown characteristic")
            }
        }
        refreshReadings()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("Received update for \(characteristic.uuid.uuidString)")
        switch characteristic.uuid {
        case BatteryService.batteryLevelCharacteristicCBUUID:
            batteryLevelPercent = characteristic.value!.getUInt8()
            print("Battery Level = \(batteryLevelPercent)")
        default:
            print("Unknown characteristic")
        }
    }
    
    func refreshReadings() {
        print("Refreshing characteristics values")
        if let c = batteryLevelCharacteristic {
            peripheral.rawPeripheral.readValue(for: c)
    }
    }
    
    init (peripheral: Peripheral, service: CBService) {
        self.peripheral = peripheral
        rawService = service
    }
}
