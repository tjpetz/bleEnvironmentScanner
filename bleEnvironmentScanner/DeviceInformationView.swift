//
//  DeviceInformationView.swift
//  bleEnvironmentScanner
//
//  Created by Thomas Petz, Jr. on 10/26/20.
//

import SwiftUI
import CoreBluetooth


struct DeviceInformationView: View {
    
    static let serviceUUID = CBUUID(string: "180A")
    static let manufacturerNameString = CBUUID(string: "2A29")
    static let modelNumberString = CBUUID(string: "2A24")
    static let serialNumberString = CBUUID(string: "2A25")
    
    @ObservedObject var service: Service

    var body: some View {
        VStack (alignment: .leading, spacing: 4) {
            Text("Device Information").font(.headline)
            Spacer()
            if let c = service.getCharacteristic(cbuuid: DeviceInformationView.manufacturerNameString), let v = c.value {
                CharacteristicView(characteristic: c) {
                    "Manufacturer Name: \(decodeString(v))"
                }
            }
            if let c = service.getCharacteristic(cbuuid: DeviceInformationView.modelNumberString), let v = c.value {
                CharacteristicView(characteristic: c) {
                    "Model Number: \(decodeString(v))"
                }
            }
            if let c = service.getCharacteristic(cbuuid: DeviceInformationView.serialNumberString), let v = c.value {
                CharacteristicView(characteristic: c) {
                    "Serial Number: \(decodeString(v))"
                }
            }
        }
        .padding(4)    }
}

//struct DeviceInformationView_Previews: PreviewProvider {
//    static var previews: some View {
//        DeviceInformationView()
//    }
//}
