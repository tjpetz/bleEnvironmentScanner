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
            if let c = service.getCharacteristic(cbuuid: DeviceInformationView.manufacturerNameString) {
                CharacteristicView(characteristic: c) {
                    "Manufacturer Name: \(decodeString(c.value))"
                }
            }
            if let c = service.getCharacteristic(cbuuid: DeviceInformationView.modelNumberString) {
                CharacteristicView(characteristic: c) {
                    "Model Number: \(decodeString(c.value))"
                }
            }
            if let c = service.getCharacteristic(cbuuid: DeviceInformationView.serialNumberString) {
                CharacteristicView(characteristic: c) {
                    "Serial Number: \(decodeString(c.value))"
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
