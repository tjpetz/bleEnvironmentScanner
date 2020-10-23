//
//  Service.swift
//  bleEnvironmentScanner
//
//  Created by Thomas Petz, Jr. on 10/22/20.
//

import Foundation
import CoreBluetooth

class Service: NSObject, ObservableObject, Identifiable {
    
    var characteristics: [Characteristic] = []
    var rawService: CBService
    var uuid: CBUUID
    var peripheral: Peripheral
    
    init(peripheral: Peripheral, service: CBService) {
        self.peripheral = peripheral
        rawService = service
        self.uuid = service.uuid
    }
}
