//
//  ServicesListView.swift
//  bleEnvironmentScanner
//
//  Created by Thomas Petz, Jr. on 10/16/20.
//

import SwiftUI

struct ServicesListView: View {
    @ObservedObject var peripheral: Peripheral
    
    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    if (peripheral.environmentService != nil) {
                            NavigationLink(destination: EnvironmentServiceView(environmentService: peripheral.environmentService!)) {
                                Text("Environment Service")
                            }
                        }
                    
                    List (peripheral.otherServices) {
                        service in
                        NavigationLink(destination: GenericServiceView(service: service)) {
                            Text("Other Service")
                        }
                    }
                }
            }
            Spacer()
        }
    }
}

//struct ServicesListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ServicesListView()
//    }
//}
