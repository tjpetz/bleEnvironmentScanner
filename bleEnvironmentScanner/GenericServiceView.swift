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
                CharacteristicCell(characteristic: characteristic)
            }
            Spacer()
         }.padding(4)
    }
}

struct CharacteristicCell: View {
    
    @ObservedObject var characteristic: Characteristic
    
    var body: some View {
        CharacteristicView(characteristic: characteristic) {
            "\(characteristic.uuid.uuidString)  \(characteristic.value?.hexEncodedString() ?? "")"
        }
    }
}

//struct GenericServiceView_Previews: PreviewProvider {
//    static var previews: some View {
//        GenericServiceView(service: nil)
//    }
//}
