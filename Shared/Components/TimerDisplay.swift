//
//  TimerDisplay.swift
//  Tempo (iOS)
//
//  Created by Romain Penchenat on 09/09/2021.
//

import SwiftUI

struct TimerDisplay: View {
    
    @EnvironmentObject private var link:TempoLink
    
    private var minutes: String {
        let m = link.minutesDisplay != nil ? String(link.minutesDisplay!) : "--"
        return m.count == 1 ? "0\(m)" : m
    }
    private var seconds: String {
        let s = link.secondsDisplay != nil ? String(link.secondsDisplay!) : "--"
        return s.count == 1 ? "0\(s)" : s
    }
    
    var body: some View {
        HStack(spacing: 8) {
            HStack {
                Spacer()
                Text(minutes)
            }
            Text(":")
            HStack {
                Text(seconds)
                Spacer()
            }
        }
        .font(.largeTitle)
        .padding(.bottom, 56)
    }
}

struct TimerDisplay_Previews: PreviewProvider {
    static var previews: some View {
        TimerDisplay()
            .environmentObject(TempoLink())
    }
}
