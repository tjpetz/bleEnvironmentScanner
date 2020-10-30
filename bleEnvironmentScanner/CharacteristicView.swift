//
//  CharacteristicView.swift
//  bleEnvironmentScanner
//
//  Created by Thomas Petz, Jr. on 10/24/20.
//

import SwiftUI

struct CharacteristicView: View {
    
    @ObservedObject var characteristic: Characteristic
    var render: () -> String
    
    var body: some View {
        HStack {
            Text(render())
            Spacer()
            if (characteristic.characteristic.properties.contains(.read) && characteristic.service.peripheral.isConnectable) {
                Button("Refresh") {
                    characteristic.characteristic.service.peripheral.readValue(for: characteristic.characteristic)
                }
            }
        }.font(.caption)
    }
}


//struct CharacteristicView_Previews: PreviewProvider {
//    static var previews: some View {
//        CharacteristicView()
//    }
//}
