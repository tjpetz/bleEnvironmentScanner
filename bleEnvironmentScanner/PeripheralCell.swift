//
//  PeripheralCell.swift
//  bleEnvironmentScanner
//
//  Created by Thomas Petz, Jr. on 10/21/20.
//

import SwiftUI

struct PeripheralCell: View {
    @ObservedObject var peripheral: Peripheral
    
    var body: some View {
        HStack {
            VStack (alignment: .leading, spacing: 2) {
                Text(peripheral.uuid.uuidString)
                Text(peripheral.localName ?? "").font(.caption).foregroundColor(.secondary)
            }
            Spacer()
            SignalStrengthView(signalStrength: peripheral.rssi)
        }.padding(4)
    }
}
