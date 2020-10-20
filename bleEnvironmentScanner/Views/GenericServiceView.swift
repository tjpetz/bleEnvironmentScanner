//
//  GenericServiceView.swift
//  bleEnvironmentScanner
//
//  Created by Thomas Petz, Jr. on 10/16/20.
//

import SwiftUI
import CoreBluetooth

struct GenericServiceView: View {
    var service: GenericService?
    
    var body: some View {
        VStack {
            Text("Hello, World!")
            Spacer()
        }
    }
}

struct GenericServiceView_Previews: PreviewProvider {
    static var previews: some View {
        GenericServiceView(service: nil)
    }
}
