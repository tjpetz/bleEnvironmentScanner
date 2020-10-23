//
//  GenericServiceView.swift
//  bleEnvironmentScanner
//
//  Created by Thomas Petz, Jr. on 10/16/20.
//

import SwiftUI
import CoreBluetooth

struct GenericServiceView: View {
    
    @State var service: Service?
    
    var body: some View {
        VStack (alignment: .leading, spacing: 4) {
            Text(service!.uuid.uuidString).font(.headline)
            Spacer()
            ForEach (service!.characteristics, id: \.self) {
                characteristic in
                HStack {
                    Text("\(characteristic.uuid.uuidString): ")
                    Text(characteristic.characteristic.value?.hexEncodedString() ?? "")
                    if (characteristic.characteristic.properties.contains(CBCharacteristicProperties.read)) {
                        Spacer()
                        Button("Refresh", action: {})
                    }
                }.font(.caption)
            }
            Spacer()
         }.padding(4)
    }
}

//struct GenericServiceView_Previews: PreviewProvider {
//    static var previews: some View {
//        GenericServiceView(service: nil)
//    }
//}
