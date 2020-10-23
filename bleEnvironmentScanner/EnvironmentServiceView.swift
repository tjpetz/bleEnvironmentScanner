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
                HStack{
                    Text(String(format: "Temperature: %0.2f C", Float((temp.value?.getInt16())!) / 100.0))
                    Spacer()
                    Button("Refresh") { service.peripheral.rawPeripheral.readValue(for: temp.characteristic)
                    }
                }.font(.caption)
            }
            if let humidity = service.getCharacteristic(cbuuid: EnvironmentServiceView.humidityCharacteristicCBUUID)?.value?.getInt16() {
                HStack{
                    Text(String(format: "Humidity: %0.2f RH %%", Float(humidity) / 100.0))
                    Spacer()
                    Button("Refresh", action: {})
                }.font(.caption)
            }
            if let pressure = service.getCharacteristic(cbuuid: EnvironmentServiceView.pressureCharacteristicCBUUID)?.value?.getInt32() {
                HStack{
                    Text(String(format: "Pressure: %0.2f kPa", Float(pressure) / 10000.0))
                    Spacer()
                    Button("Refresh", action: {})
                }.font(.caption)
            }
            if let location = service.getCharacteristic(cbuuid: EnvironmentServiceView.locationNameCharacteristicCBUUID) {
                HStack{
                    Text("Location: \(String(data: location.value!, encoding: String.Encoding.utf8) ?? "")")
                    Spacer()
                    Button("Refresh", action: {})
                }.font(.caption)
            }
        }
        .padding(4)
        
    }
}

//struct EnvironmentServiceView_Previews: PreviewProvider {
//    static var previews: some View {
//        EnvironmentServiceView()
//    }
//}
