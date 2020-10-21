//
//  GenericService.swift
//  bleEnvironmentScanner
//
//  Created by Thomas Petz, Jr. on 10/15/20.
//

import Foundation
import CoreBluetooth

class GenericService: NSObject, Identifiable, ObservableObject {
    var rawService: CBService
    
    init (_ service: CBService) {
        rawService = service
    }
}
