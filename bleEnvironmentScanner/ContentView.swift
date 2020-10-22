//
//  ContentView.swift
//  bleEnvironmentScanner
//
//  Created by Thomas Petz, Jr. on 10/21/20.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var bleManager: BLEManager
    @State var selectedPeripheral: Peripheral?
    
    var body: some View {
        VStack {
            // Layout in an HStack with a spacer so the view fills the width
            HStack {
                NavigationView {
                    PeripheralsList(selectedPeripheral: $selectedPeripheral)
                    DetailsView(peripheral: $selectedPeripheral)
                }
                Spacer()
            }
            HStack {
                Button("Start Scanning", action: {bleManager.scan()}).disabled(bleManager.isScanning)
                Button("Stop Scanning", action: {bleManager.stopScanning()}).disabled(!bleManager.isScanning)
            }
            .padding(10)
        }
    }
}

struct PeripheralsList: View {
    
    @EnvironmentObject var bleManager: BLEManager
    @Binding var selectedPeripheral: Peripheral?
    
    var body: some View {
        List(bleManager.peripherals, id: \.self, selection: $selectedPeripheral) {
            peripheral in
            PeripheralCell(peripheral: peripheral)
        }
        .listStyle(SidebarListStyle())
        .frame(minWidth: 400, minHeight: 200, maxHeight: .infinity)
    }
}

struct DetailsView: View {
    
    @Binding var peripheral: Peripheral?
    
    var body: some View {
        List {
            if let s = peripheral?.environmentService {
                EnvironmentServiceView(environmentService: s)
            }
            if let s = peripheral?.batteryService {
                BatteryServiceView(batteryService: s)
            }
            if let s = peripheral?.otherServices {
                ForEach(s) {
                    service in
                    GenericServiceView(service: service)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(BLEManager())
    }
}
