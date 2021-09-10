//
//  TempoButton.swift
//  Tempo (iOS)
//
//  Created by Romain Penchenat on 10/09/2021.
//

import SwiftUI

struct TempoButton: View {
    
    @EnvironmentObject var link:TempoLink
    
    var shadowEnd: CGFloat {
        guard let minutes = link.minutesDisplay else { return 1 }
        return CGFloat(minutes) / 60
    }
    
    var shadowColor: Color {
        guard link.isConnected else {
            return Color.tSand
        }
        return Color.tGold
    }
    
    
    var body: some View {
        ZStack {
            ArcCircle(start: 0, end: shadowEnd)
                .shadow(color: shadowColor.opacity(0.8), radius: 60, x: 0, y: 0)
            ArcCircle(start: 0, end: shadowEnd)
                .stroke(shadowColor, lineWidth: 2)
            Circle()
                .fill(Color.tWhite)
            Button(action: link.play, label: {
                Image("PlayButton")
                    .resizable()
                    .foregroundColor(Color.tSoil)
                    .frame(width: 54, height: 54)
                    .padding(.all, 16)
            })
            .disabled(!link.isConnected)
            .opacity(link.isConnected ? 1 : 0)
            .scaleEffect(link.isConnected ? 1 : 0.75)
            .rotationEffect(link.isConnected ? .zero : Angle(radians: .pi * 0.25))
        }
    }
    
}

struct TempoButton_Previews: PreviewProvider {
    static var previews: some View {
        TempoButton()
            .environmentObject(TempoLink())
    }
}
