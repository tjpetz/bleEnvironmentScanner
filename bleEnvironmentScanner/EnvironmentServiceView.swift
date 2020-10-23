//
//  EnvironmentServiceView.swift
//  bleEnvironmentScanner
//
//  Created by Thomas Petz, Jr. on 10/15/20.
//

import SwiftUI
import CoreBluetooth

struct EnvironmentServiceView: View {
    @ObservedObject var environmentService: Service
    
    static let serviceUUID = CBUUID(string: "181A")
    
    static let temperatureCharacteristicCBUUID = CBUUID(string: "2A6E")
    static let humidityCharacteristicCBUUID = CBUUID(string: "2A6F")
    static let pressureCharacteristicCBUUID = CBUUID(string: "2A6D")
    static let locationNameCharacteristicCBUUID = CBUUID(string: "2AB5")
 
    var body: some View {
        VStack (alignment: .leading, spacing: 4) {
            Text("Environment Service").font(.headline)
            Spacer()
        }
        .padding(4)
        
    }
}

//struct EnvironmentServiceView_Previews: PreviewProvider {
//    static var previews: some View {
//        EnvironmentServiceView()
//    }
//}
