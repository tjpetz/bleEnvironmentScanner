//
//  BLEConfigurationView.swift
//  bleEnvironmentScanner
//
//  Created by Thomas Petz, Jr. on 10/24/20.
//

import SwiftUI
import CoreBluetooth

struct BLEConfigurationView: View {
    
    static let serviceUUID = CBUUID(string: "7f76c1b2-c592-4ace-8089-47bf14d07ced")
    static let sensorNameCharacteristicUUID = CBUUID(string: "641aff8f-217e-4ddb-aece-3053b128c27d")
    static let sensorLocationCharacteristicUUID = CBUUID(string: "52b8d6c4-cd20-4f51-bf71-ea0de788ebb4")
    static let humidityGreenLimitCharacteristicUUID = CBUUID(string: "ebf92cf8-2744-4df2-be70-e856fcaf01a7")
    static let humidityAmberLimitCharacteristicUUID = CBUUID(string: "90441958-8975-4f62-aa13-08bdb86acd16")
    static let configIsLockedCharacteristicUUID = CBUUID(string: "32b6a19f-ddac-45db-a1b5-8a7dbe9a76fc")
    static let lockPasswordCharacteristicUUID = CBUUID(string: "3ffb9262-18a2-4acf-918c-2f8932577c48")
    
    @ObservedObject var service: Service
    
    var body: some View {
        VStack (alignment: .leading, spacing: 4) {
            Text("BLE Sensor Configuration Service").font(.headline)
            Spacer()
            if let sensorNameCharacteristic = service.getCharacteristic(cbuuid: BLEConfigurationView.sensorNameCharacteristicUUID), let sensorName = sensorNameCharacteristic.value {
                CharacteristicView(characteristic: sensorNameCharacteristic) {
                    "Sensor Name: \(decodeString(sensorName))"
                }
            }
            if let sensorLocationCharacteristic = service.getCharacteristic(cbuuid: BLEConfigurationView.sensorLocationCharacteristicUUID), let sensorLocation = sensorLocationCharacteristic.value {
                CharacteristicView(characteristic: sensorLocationCharacteristic) {
                    "Sensor Location: \(decodeString(sensorLocation))"
                }
            }
            if let characteristic = service.getCharacteristic(cbuuid: BLEConfigurationView.humidityGreenLimitCharacteristicUUID), let value = characteristic.value {
                CharacteristicView(characteristic: characteristic) {
                    String(format: "Humidity Green Limit: %d", Int(value.getInt16()))
                }
            }
            if let characteristic = service.getCharacteristic(cbuuid: BLEConfigurationView.humidityAmberLimitCharacteristicUUID), let value = characteristic.value {
                CharacteristicView(characteristic: characteristic) {
                    String(format: "Humidity Amber Limit: %d", Int(value.getInt16()))
                }
            }
            if let characteristic = service.getCharacteristic(cbuuid: BLEConfigurationView.configIsLockedCharacteristicUUID), let value = characteristic.value {
                CharacteristicView(characteristic: characteristic) {
                    String(format: "Configuration is Locked: %d", Int(value.getUInt8()))
                }
            }
            if let characteristic = service.getCharacteristic(cbuuid: BLEConfigurationView.lockPasswordCharacteristicUUID) {
                CharacteristicView(characteristic: characteristic) {
                    "Lock Password: "
                }
            }
      }
        .padding(4)
    }
}

//struct BLEConfigurationView_Previews: PreviewProvider {
//    static var previews: some View {
//        BLEConfigurationView()
//    }
//}
