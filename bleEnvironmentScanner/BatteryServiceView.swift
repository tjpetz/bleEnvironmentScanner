//
//  BatteryServiceView.swift
//  bleEnvironmentScanner
//
//  Created by Thomas Petz, Jr. on 10/22/20.
//

import SwiftUI

struct BatteryServiceView: View {
    
    static let serviceUUID = CBUUID(string: "180F")
    
    @ObservedObject var batteryService: Service
    
    var body: some View {
        VStack (alignment: .leading, spacing: 4) {
            Text("Battery Service").font(.headline)
            Spacer()
        }
        .padding(4)
        
    }
}

//struct BatteryServiceView_Previews: PreviewProvider {
//    static var previews: some View {
//        BatteryServiceView()
//    }
//}
