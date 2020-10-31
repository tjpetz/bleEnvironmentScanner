//
//  EnvironmentServiceView.swift
//  bleEnvironmentScanner
//
//  Created by Thomas Petz, Jr. on 10/15/20.
//

import SwiftUI
import CoreBluetooth

struct EnvironmentServiceView: View {
    
    @ObservedObject var service: Service
    
    static let serviceUUID = CBUUID(string: "181A")
    
    static let temperatureCharacteristicCBUUID = CBUUID(string: "2A6E")
    static let humidityCharacteristicCBUUID = CBUUID(string: "2A6F")
    static let pressureCharacteristicCBUUID = CBUUID(string: "2A6D")
    static let locationNameCharacteristicCBUUID = CBUUID(string: "2AB5")
 
    var body: some View {
        VStack (alignment: .leading, spacing: 4) {
            Text("Environment Service").font(.headline)
            Spacer()
            if let temp = service.getCharacteristic(cbuuid: EnvironmentServiceView.temperatureCharacteristicCBUUID) {
                CharacteristicView(characteristic: temp) {
                    String(format: "Temperature: %0.2f C", Float((temp.value?.getInt16()) ?? -4000) / 100.0)
                }
            }
            if let humidity = service.getCharacteristic(cbuuid: EnvironmentServiceView.humidityCharacteristicCBUUID) {
                CharacteristicView(characteristic: humidity) {
                    String(format: "Humidity: %0.2f RH %%", Float((humidity.value?.getInt16()) ?? 0) / 100.0)
                }
            }
            if let pressure = service.getCharacteristic(cbuuid: EnvironmentServiceView.pressureCharacteristicCBUUID) {
                CharacteristicView(characteristic: pressure) {
                    String(format: "Pressure: %0.2f kPa", Float((pressure.value?.getInt32()) ?? 0) / 10000.0)
                }
            }
            if let location = service.getCharacteristic(cbuuid: EnvironmentServiceView.locationNameCharacteristicCBUUID) {
                CharacteristicView(characteristic: location) {
                    "Location: \(decodeString(location.value))"
                }
            }
        }
        .padding(4)
        
    }
}

