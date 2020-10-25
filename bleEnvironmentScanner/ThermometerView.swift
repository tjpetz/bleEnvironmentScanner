//
//  ThermometerView.swift
//  bleEnvironmentScanner
//
//  Created by Thomas Petz, Jr. on 10/24/20.
//

import SwiftUI

struct ThermometerView: View {
    
    var range: Range<Int>
    var temp: Float
    
    var body: some View {
        Rectangle()
        .foregroundColor(.red)
    }
}

struct ThermometerView_Previews: PreviewProvider {
    static var previews: some View {
        ThermometerView(range: -20..<40, temp: 18.0)
    }
}
