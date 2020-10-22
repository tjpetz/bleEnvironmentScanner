//
//  EnvironmentService.swift
//  bleEnvironmentScanner
//
//  Created by Thomas Petz, Jr. on 10/15/20.
//

import Foundation
import CoreBluetooth

class EnvironmentService: NSObject, ObservableObject, Identifiable, CBPeripheralDelegate {
    
    static let environmentServiceCBUUID = CBUUID(string: "181A")
    static let temperatureCharacteristicCBUUID = CBUUID(string: "2A6E")
    static let humidityCharacteristicCBUUID = CBUUID(string: "2A6F")
    static let pressureCharacteristicCBUUID = CBUUID(string: "2A6D")
    static let locationNameCharacteristicCBUUID = CBUUID(string: "2AB5")
    
    @Published var peripheral: Peripheral
    var rawService: CBService?
    var temperatureCharacteristic: CBCharacteristic? = nil
    var humidityCharacteristic: CBCharacteristic? = nil
    var pressureCharacteristic: CBCharacteristic? = nil
    var locationCharacteristic: CBCharacteristic? = nil
    
    @Published var temperature: Float = 0
    @Published var humidity: Float = 0
    @Published var pressure: Float = 0
    @Published var location: String = ""
    
    func discoverCharacteristics() {
        peripheral.rawPeripheral.delegate = self
        peripheral.rawPeripheral.discoverCharacteristics(nil, for: rawService!)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("Found \(service.characteristics!.count) characteristic(s) for \(service.uuid.uuidString)")
        for c in service.characteristics! {
            print("Characteristic \(c.uuid)")
            switch c.uuid {
            case EnvironmentService.temperatureCharacteristicCBUUID:
                temperatureCharacteristic = c
            case EnvironmentService.humidityCharacteristicCBUUID:
                humidityCharacteristic = c
            case EnvironmentService.pressureCharacteristicCBUUID:
                pressureCharacteristic = c
            case EnvironmentService.locationNameCharacteristicCBUUID:
                locationCharacteristic = c
            default:
                print("Unknown characteristic")
            }
        }
        refreshReadings()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("Received update for \(characteristic.uuid.uuidString)")
        switch characteristic.uuid {
        case EnvironmentService.temperatureCharacteristicCBUUID:
            temperature = Float(characteristic.value!.getInt16()) / 100.0
            print("Temperature = \(temperature)")
        case EnvironmentService.humidityCharacteristicCBUUID:
            humidity = Float(characteristic.value!.getInt16()) / 100.0
            print("Humidity = \(humidity)")
        case EnvironmentService.pressureCharacteristicCBUUID:
            pressure = Float(characteristic.value!.getInt32()) / 10000.0
            print("Pressure = \(pressure)")
        case EnvironmentService.locationNameCharacteristicCBUUID:
            location = String(data: characteristic.value!, encoding: String.Encoding.utf8)!
            print("Location = \(location)")
        default:
            print("Unknown characteristic")
        }
    }
    
    func refreshReadings() {
        print("Refreshing characteristics values")
        peripheral.rawPeripheral.readValue(for: temperatureCharacteristic!)
        peripheral.rawPeripheral.readValue(for: humidityCharacteristic!)
        peripheral.rawPeripheral.readValue(for: pressureCharacteristic!)
        if locationCharacteristic != nil {
            peripheral.rawPeripheral.readValue(for: locationCharacteristic!)
        }
    }
    
    init (peripheral: Peripheral, service: CBService) {
        self.peripheral = peripheral
        rawService = service
    }
}
