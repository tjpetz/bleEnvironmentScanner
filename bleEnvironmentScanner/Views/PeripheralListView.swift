//
//  ContentView.swift
//  bleEnvironmentScanner//

import SwiftUI
import Combine

struct PeripheralListView: View {
    
    @EnvironmentObject var bleManager: BLEManager
    
    var body: some View {
        VStack {
            Text("Found \(bleManager.peripherals.count) peripherals")
            NavigationView {
                List {
                    ForEach(bleManager.peripherals) {
                        peripheral in
                        NavigationLink(destination: ServicesListView(peripheral: peripheral)) {
                            HStack {
                                Text(peripheral.uuid.uuidString)
                                Spacer()
                                Text("\(peripheral.rssi)")
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
