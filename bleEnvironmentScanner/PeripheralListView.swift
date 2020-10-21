//
//  ContentView.swift
//  bleEnvironmentScanner//

import SwiftUI

struct PeripheralListView: View {
    
    @EnvironmentObject var bleManager: BLEManager
    
    var body: some View {
        VStack {
            Text("Peripherals").font(.headline)
            NavigationView {
            List() {
                ForEach(bleManager.peripherals, id: \.self) {
                    peripheral in
                    NavigationLink(destination: ServicesListView(peripheral: peripheral)) {
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
            }.listStyle(SidebarListStyle())
            }
            HStack {
                Button("Scan", action:{bleManager.scan()}).disabled(bleManager.isScanning)
                Button("Stop Scanning", action: {bleManager.stopScanning()}).disabled(!bleManager.isScanning)
            }
        }.padding()
    }
}

struct PeripheralList_Previews: PreviewProvider {
    static var previews: some View {
        PeripheralListView().environmentObject(BLEManager())
    }
}
