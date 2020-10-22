//
//  GenericServiceView.swift
//  bleEnvironmentScanner
//
//  Created by Thomas Petz, Jr. on 10/16/20.
//

import SwiftUI
import CoreBluetooth

struct GenericServiceView: View {
    
    @ObservedObject var service: GenericService
    
    var body: some View {
        VStack (alignment: .leading, spacing: 4) {
            Text(service.uuid?.uuidString ?? "Unknown").font(.headline)
            Spacer()
            List(service.characteristics) {
                characteristic in
                Text(characteristic.uuid.uuidString)
            }
            Spacer()
            Button("Refresh", action: {})
        }.padding(4)
    }
}

//struct GenericServiceView_Previews: PreviewProvider {
//    static var previews: some View {
//        GenericServiceView(service: nil)
//    }
//}
