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
    @Published var environmentService: EnvironmentService?
    @Published var otherServices: [GenericService] = []
    
    @Published var uuid: CBUUID
    @Published var localName: String?
    @Published var rssi: Int
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("Discovered \(peripheral.services!.count) service(s) for \(peripheral.identifier.uuidString)")
        
        for s in peripheral.services! {
            print("Found service \(s.uuid)")
            switch s.uuid {
            case EnvironmentService.environmentServiceCBUUID:
                environmentService = EnvironmentService(peripheral: self, service: s)
                environmentService!.discoverCharacteristics()
            default:
                otherServices.append(GenericService(s))
            }
        }
        objectWillChange.send()
    }
    
    func discoverServices() {
        rawPeripheral.delegate = self
        uuid = CBUUID(nsuuid: rawPeripheral.identifier)
        localName = rawPeripheral.name ?? ""
        rawPeripheral.discoverServices(nil)
    }
    
    init(_ peripheral: CBPeripheral) {
        rawPeripheral = peripheral
        uuid = CBUUID(nsuuid: peripheral.identifier)
        rssi = -90
    }
    
    init(_ peripheral: CBPeripheral, scanRSSI rssi: Int) {
        rawPeripheral = peripheral
        uuid = CBUUID(nsuuid: peripheral.identifier)
        self.rssi = rssi
    }
}
