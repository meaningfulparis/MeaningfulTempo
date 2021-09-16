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
        guard let minutes = link.minutesDisplay else { return 0.33 }
        switch link.viewMode {
        case .Settings:
            return CGFloat(minutes) / 60
        case .RunningTimer:
            return 1
        case .PausedTimer:
            return 1
        case .WifiConfiguration:
            return 0
        }
    }
    
    var shadowColor: Color {
        switch link.connexionStatus {
        case .Connected:
            return link.isTimerExceeded ? Color.tBlue : Color.tGold
        case .Connecting:
            return Color.tBlue
        case .Searching:
            return Color.tBlue.opacity(0.5)
        }
    }
    
    
    var body: some View {
        ZStack {
            ArcCircle(start: 0, end: shadowEnd)
                .fill(Color.clear)
                .shadow(color: shadowColor.opacity(0.8), radius: link.connexionStatus == .Connecting ? 90 : 60, x: 0, y: 0)
                .transformEffect(.init(translationX: 0, y: link.viewMode == .Settings ? 0 : 40))
                .opacity(link.viewMode == .RunningTimer ? 0.2 + abs(link.timerProgression * 0.8) : 1)
            ArcCircle(start: 0, end: shadowEnd)
                .stroke(shadowColor, lineWidth: link.viewMode == .RunningTimer ? 0 : 2)
            Circle()
                .fill(link.connexionStatus == .Connected ? Color.tWhite : Color.tCream)
            Button(action: mainButtonAction, label: {
                Image(link.viewMode == .RunningTimer ? "PauseButton" : "PlayButton")
                    .resizable()
                    .foregroundColor(Color.tSoil)
                    .frame(width: 54, height: 54)
                    .padding(.all, 16)
            })
            .disabled(link.connexionStatus != .Connected)
            .opacity(link.connexionStatus == .Connected ? 1 : 0)
            .scaleEffect(link.connexionStatus == .Connected ? 1 : 0.75)
            .rotationEffect(link.connexionStatus == .Connected ? .zero : Angle(radians: .pi * -0.25))
        }
    }
    
    private func mainButtonAction() {
        link.viewMode == .RunningTimer ? link.pause() : link.play()
    }
    
}

struct TempoButton_Previews: PreviewProvider {
    static var previews: some View {
        TempoButton()
            .environmentObject(TempoLink())
    }
}
