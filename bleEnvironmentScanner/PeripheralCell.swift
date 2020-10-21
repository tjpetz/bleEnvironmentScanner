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
            VStack (alignment: .leading) {
                Text(peripheral.uuid.uuidString)
                Text(peripheral.localName ?? "").font(.footnote).foregroundColor(.secondary)
            }
            Spacer()
            SignalStrengthView(signalStrength: peripheral.rssi)
        }
    }
}

//struct PeripheralCell_Previews: PreviewProvider {
//    static var previews: some View {
//        PeripheralCell()
//    }
//}
