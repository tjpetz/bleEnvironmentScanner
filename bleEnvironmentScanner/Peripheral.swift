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
    @Published var batteryService: BatteryService?
    @Published var otherServices: [GenericService] = []
    
    @Published var uuid: CBUUID
    @Published var localName: String?
    @Published var rssi: Int

    // MARK: - Service Discovery
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("Discovered \(peripheral.services!.count) service(s) for \(peripheral.identifier.uuidString)")
        
        for service in peripheral.services! {
            print("Found service \(service.uuid)")
            switch service.uuid {
            case EnvironmentService.environmentServiceCBUUID:
                environmentService = EnvironmentService(peripheral: self, service: service)
            case BatteryService.batteryServiceCBUUID:
                batteryService = BatteryService(peripheral: self, service: service)
            default:
                otherServices.append(GenericService(peripheral: self, service: service))
            }
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
        switch service.uuid {
        case EnvironmentService.environmentServiceCBUUID:
            return environmentService
        case BatteryService.batteryServiceCBUUID:
            return batteryService
        default:
            for knownService in otherServices {
                if knownService.uuid == service.uuid {
                    return knownService
                }
            }
            return nil
        }
    }
    
    // MARK: Characteristic discovery and processing
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("Found \(service.characteristics!.count) characteristic(s) for \(service.uuid.uuidString)")
        
        if let s = findService(service: service) {
            for c in service.characteristics! {
                print("Characteristic \(c.uuid)")
                s.characteristics.append(Characteristic(service: s, characteristic: c))
            }
//            refreshReadings()
        } else {
            print("Unknown service !!!!!")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("Received update for \(characteristic.uuid.uuidString)")
    }

    // MARK: Constructors
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
