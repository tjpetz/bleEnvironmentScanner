//
//  EnvironmentServiceView.swift
//  bleEnvironmentScanner
//
//  Created by Thomas Petz, Jr. on 10/15/20.
//

import SwiftUI

struct EnvironmentServiceView: View {
    @ObservedObject var environmentService: EnvironmentService
    
    var body: some View {
        VStack {
            Text(String(format: "Temperature: %0.2f C", environmentService.temperature))
            Text(String(format: "Humidity: %0.2f % RH", environmentService.humidity))
            Text(String(format: "Pressure: %0.2f kP", environmentService.pressure))
            Text("Location: \(environmentService.location)")
            Spacer()
        }
    }
}

//struct EnvironmentServiceView_Previews: PreviewProvider {
//    static var previews: some View {
//        EnvironmentServiceView()
//    }
//}