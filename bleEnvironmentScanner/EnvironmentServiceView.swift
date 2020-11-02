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
            if let temp = service.getCharacteristic(cbuuid: EnvironmentServiceView.temperatureCharacteristicCBUUID), let val = temp.value {
//                    Gauge(value: Float(val.getInt16()) / 100.0, minRange : -20, maxRange: 100)
                    CharacteristicView(characteristic: temp) {
                        String(format: "Temperature: %0.2f C", Float(val.getInt16()) / 100.0)
                    }
            }
            if let humidity = service.getCharacteristic(cbuuid: EnvironmentServiceView.humidityCharacteristicCBUUID), let val = humidity.value {
                CharacteristicView(characteristic: humidity) {
                    String(format: "Humidity: %0.2f RH %%", Float(val.getInt16()) / 100.0)
                }
            }
            if let pressure = service.getCharacteristic(cbuuid: EnvironmentServiceView.pressureCharacteristicCBUUID), let val = pressure.value {
                CharacteristicView(characteristic: pressure) {
                    String(format: "Pressure: %0.2f kPa", Float(val.getInt32()) / 10000.0)
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

