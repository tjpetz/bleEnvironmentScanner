//
//  ThermometerView.swift
//  bleEnvironmentScanner
//
//  Created by Thomas Petz, Jr. on 10/24/20.
//

import SwiftUI

struct Gauge: View {
    var value: Float
    var minRange: Float
    var maxRange: Float
    
    private func scaleValue() -> CGFloat {
        if value <= minRange {
            return CGFloat(0)
        } else if value >= maxRange {
            return CGFloat(1.0)
        } else {
            return CGFloat((value - minRange) / (maxRange - minRange))
        }
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .scale(x: scaleValue(), anchor: .leading)
                .foregroundColor(.red)
                .opacity(0.70)
            Rectangle()
                .inset(by: inset)
                .stroke(lineWidth: 2)
                .foregroundColor(.black)
            Text(String(format: "%0.1f C", value))
        }.frame(height: 20)
    }
    
    private let cornerRadius = CGFloat(8.0)
    private let inset = CGFloat(2.0)
}

struct Gauge_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Gauge(value: 15.0, minRange: -20.0, maxRange: 100.0)
            Gauge(value: 90.0, minRange: 10.0, maxRange: 100.0)
        }
    }
}
