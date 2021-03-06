//
//  Service.swift
//  bleEnvironmentScanner
//
//  Created by Thomas Petz, Jr. on 10/22/20.
//

import Foundation
import CoreBluetooth

class Service: NSObject, ObservableObject, Identifiable {
    
    @Published var uuid: CBUUID
    var rawService: CBService
    var peripheral: Peripheral

    @Published var characteristics: [Characteristic] = []

    func getCharacteristic(cbuuid: CBUUID) -> Characteristic? {
        for characteristic in characteristics {
            if characteristic.uuid == cbuuid {
                return characteristic
            }
        }
        return nil
    }
    
    init(peripheral: Peripheral, service: CBService) {
        self.peripheral = peripheral
        rawService = service
        self.uuid = service.uuid
    }
}
