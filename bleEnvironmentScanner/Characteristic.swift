//
//  Characteristic.swift
//  bleEnvironmentScanner
//
//  Created by Thomas Petz, Jr. on 10/22/20.
//

import Foundation
import CoreBluetooth
import Combine

class Characteristic: NSObject, ObservableObject, Identifiable {
    
    @Published var uuid: CBUUID
    var service: Service
    var characteristic: CBCharacteristic
    
    init (service: Service, characteristic: CBCharacteristic) {
        self.service = service
        self.characteristic = characteristic
        uuid = characteristic.uuid
    }
}
