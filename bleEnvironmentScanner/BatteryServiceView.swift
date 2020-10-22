//
//  BatteryServiceView.swift
//  bleEnvironmentScanner
//
//  Created by Thomas Petz, Jr. on 10/22/20.
//

import SwiftUI

struct BatteryServiceView: View {
    @ObservedObject var batteryService: BatteryService
    
    var body: some View {
        VStack (alignment: .leading, spacing: 4) {
            Text("Battery Service").font(.headline)
            Spacer()
            Text(String(format: "Remaining Power: %d %%", batteryService.batteryLevelPercent))
            Spacer()
            Button("Refresh", action: { batteryService.refreshReadings() })
        }
        .padding(4)
        
    }
}

//struct BatteryServiceView_Previews: PreviewProvider {
//    static var previews: some View {
//        BatteryServiceView()
//    }
//}
