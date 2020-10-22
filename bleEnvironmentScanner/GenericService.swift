//
//  GenericService.swift
//  bleEnvironmentScanner
//
//  Created by Thomas Petz, Jr. on 10/15/20.
//

import Foundation
import CoreBluetooth

class GenericService: Service, CBPeripheralDelegate {

    var peripheral: Peripheral
    var rawService: CBService?

    @Published var characteristics: [Characteristic] = []
    @Published var uuid: CBUUID?
    
    func discoverCharacteristics() {
        peripheral.rawPeripheral.delegate = self
        peripheral.rawPeripheral.discoverCharacteristics(nil, for: rawService!)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("Found \(service.characteristics!.count) characteristic(s) for \(service.uuid.uuidString)")
        for c in service.characteristics! {
            print("Characteristic \(c.uuid)")
            characteristics.append(Characteristic(service: self, characteristic: c))
        }
        refreshReadings()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("Received update for \(characteristic.uuid.uuidString)")
    }
    
    func refreshReadings() {
        print("Refreshing characteristics values")
//        for c in characteristics {
//            if c.properties.contains(.read) {
//                peripheral.rawPeripheral.readValue(for: c)
//            }
//        }
    }
    
    init (peripheral: Peripheral, service: CBService) {
        self.peripheral = peripheral
        rawService = service
        self.uuid = service.uuid
    }
}

