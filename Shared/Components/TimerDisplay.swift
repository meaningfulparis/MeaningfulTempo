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
        guard let minutes = link.minutesDisplay else { return "--" }
        if minutes >= 0 {
            return minutes < 10 ? "0\(minutes)" : String(minutes)
        } else {
            let m = abs(minutes) - 1
            return m < 10 ? "0\(m)" : String(m)
        }
    }
    private var seconds: String {
        guard let seconds = link.secondsDisplay else { return "--" }
        let s = abs(seconds)
        return s < 10 ? "0\(s)" : String(s)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            HStack(spacing: 8) {
                HStack {
                    Spacer()
                    Text("+")
                        .modifier(SmallTimerText())
                        .opacity(link.isTimerExceeded ? 1 : 0)
                    Text(minutes)
                }
                Text(":")
                HStack {
                    Text(seconds)
                    Spacer()
                }
            }
            .modifier(TimerText())
            .animation(nil)
            Text("\(link.timerDuration) min")
                .modifier(DetailText())
                .opacity(link.viewMode != .Settings ? 1 : 0)
        }
        .padding(.bottom, 16)
    }
}

struct TimerDisplay_Previews: PreviewProvider {
    static var previews: some View {
        TimerDisplay()
            .environmentObject(TempoLink())
    }
}
