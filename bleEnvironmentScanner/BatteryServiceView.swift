//
//  BatteryServiceView.swift
//  bleEnvironmentScanner
//
//  Created by Thomas Petz, Jr. on 10/22/20.
//

import SwiftUI
import CoreBluetooth


struct BatteryServiceView: View {
    
    static let serviceUUID = CBUUID(string: "180F")
    static let batteryCharacteristicCBUUID = CBUUID(string: "2A19")
    
    @ObservedObject var service: Service
    
    var body: some View {
        VStack (alignment: .leading, spacing: 4) {
            Text("Battery Service").font(.headline)
            Spacer()
            if let level = service.getCharacteristic(cbuuid: BatteryServiceView.batteryCharacteristicCBUUID) {
                CharacteristicView(characteristic: level) {
                    if level.value != nil {
                        return String(format: "Battery: %d %%", Int((level.value!.getUInt8())))
                    } else {
                        return ""
                    }
                }
            }
        }
        .padding(4)
    }
}


