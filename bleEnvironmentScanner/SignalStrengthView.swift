//
//  SignalStrengthView2.swift
//  bleEnvironmentScanner
//
//  Created by Thomas Petz, Jr. on 10/20/20.
//

import SwiftUI

struct SignalStrengthView: View {
    
    var signalStrength: Int
    
    private func signalStrengthColor(_ signalStrength: Int) -> Color {
        if signalStrength <= -80 {
            return Color.red
        } else if signalStrength <= -50 {
            return Color.yellow
        } else {
            return Color.green
        }
    }
    
    // Draw a height scaled rectangle, stroke if less then the limit and filled otherwise.
    private func SignalRectangle(heightScale: CGFloat, onLimit: Int) -> some View {
        let signalColor = signalStrengthColor(signalStrength)
        if signalStrength >= onLimit {
            return AnyView(Rectangle()
                .scale(x:1, y:heightScale, anchor: .bottom)
                .fill(signalColor))
        } else {
            return AnyView(Rectangle()
                .scale(x:1, y:heightScale, anchor: .bottom)
                .stroke(signalColor))
        }
    }
    
    var body: some View {
        VStack {
            HStack (spacing: 2) {
                SignalRectangle(heightScale: 0.20, onLimit: -80)
                SignalRectangle(heightScale: 0.40, onLimit: -70)
                SignalRectangle(heightScale: 0.60, onLimit: -60)
                SignalRectangle(heightScale: 0.80, onLimit: -50)
                SignalRectangle(heightScale: 1.0, onLimit: -40)
            }.padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
            Text("\(signalStrength) dBm").font(.system(size: 9, weight: .light))
        }.frame(width: 50, height: 40)
    }
}

struct SignalStrengthView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignalStrengthView(signalStrength: -100)
            SignalStrengthView(signalStrength: -80)
            SignalStrengthView(signalStrength: -70)
            SignalStrengthView(signalStrength: -55)
            SignalStrengthView(signalStrength: -40)
        }
    }
}
