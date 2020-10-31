//
//  CharacteristicView.swift
//  bleEnvironmentScanner
//
//  Created by Thomas Petz, Jr. on 10/24/20.
//

import SwiftUI

struct CharacteristicView: View {
    
    @ObservedObject var characteristic: Characteristic
    @EnvironmentObject var peripheral: Peripheral
    
    var render: () -> String
    
    var body: some View {
        HStack {
            Text(render())
            Spacer()
            if (characteristic.characteristic.properties.contains(.read) && peripheral.isConnected) {
                Button("Refresh") {
                     peripheral.rawPeripheral.readValue(for: characteristic.characteristic)
                }
            }
        }.font(.caption)
    }
}
