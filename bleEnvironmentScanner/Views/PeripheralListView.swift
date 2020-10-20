//
//  ContentView.swift
//  bleEnvironmentScanner//

import SwiftUI

struct PeripheralListView: View {
    
    @EnvironmentObject var bleManager: BLEManager
    
    var body: some View {
        VStack {
            HStack {
                Button("Scan", action:{bleManager.scan()}).disabled(bleManager.isScanning)
                Button("Stop Scanning", action: {bleManager.stopScanning()}).disabled(!bleManager.isScanning)
            }
            Text("Found \(bleManager.peripherals.count) peripherals")
            NavigationView {
                List {
                    ForEach(bleManager.peripherals) {
                        peripheral in
                        NavigationLink(destination: ServicesListView(peripheral: peripheral)) {
                            HStack {
                                VStack (alignment: .leading) {
                                    Text(peripheral.uuid.uuidString)
                                    Text(peripheral.localName ?? "").font(.footnote)
                                }
                                Spacer()
                                SignalStrengthView(signalStrength: peripheral.rssi)
                            }
                        }
                    }
                }
            }
        }.padding()
    }
}

struct PeripheralList_Previews: PreviewProvider {
    static var previews: some View {
        PeripheralListView()
    }
}
