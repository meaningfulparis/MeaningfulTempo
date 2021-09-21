//
//  TimerWheel.swift
//  Tempo (iOS)
//
//  Created by Romain Penchenat on 09/09/2021.
//

import SwiftUI

struct TimerWheel: View {
    
    struct Dial {
        var angle: Angle {
            get { _angle }
            set {
                let sanythizedNewVal = newValue + .radians(.pi / 2)
                let delta = (_angle - sanythizedNewVal).radians
                let smallestDelta:Double
                if delta > 0 {
                    smallestDelta = (delta + .pi).truncatingRemainder(dividingBy: (.pi * 2)) - .pi
                } else {
                    smallestDelta = (delta - .pi).truncatingRemainder(dividingBy: (.pi * 2)) + .pi
                }
                _angle = min(Angle(radians: 2 * .pi), max(Angle.zero, Angle(radians: _angle.radians - smallestDelta)))
            }
        }
        private var _angle:Angle = Angle(radians: .pi)
        var loading: Double = 0
        let loadingAnimation = Animation.easeInOut(duration: 10).repeatForever()
    }
    
    private var handleAngle: Angle {
        return Angle(radians: link.connexionStatus == .Connected ? Double(link.minutesDisplay ?? 0) / 30 * .pi : 0)
    }
    
    @EnvironmentObject var link:TempoLink
    
    @State private var dial = Dial()
    
    private var visibleWhenNotSearching: Double { link.connexionStatus != .Searching && link.viewMode == .Settings ? 1 : 0 }
    private var visibleWhenConnected:Double { link.connexionStatus == .Connected && link.viewMode == .Settings ? 1 : 0 }
    private var isDraggingEnabled: Bool { link.viewMode == .Settings && link.connexionStatus == .Connected }
    
    var body: some View {
        GeometryReader { g in
            let size = min(g.size.width, g.size.height)
            HStack(alignment: .center, spacing: 0) {
                Spacer()
                VStack(alignment: .center, spacing: 8) {
                    TimeIndicator(.vertical)
                        .opacity(visibleWhenNotSearching)
                    HStack(alignment: .center, spacing: 8) {
                        TimeIndicator(.horizontal)
                            .opacity(visibleWhenNotSearching)
                        ZStack(alignment: .center) {
                            TempoButton()
                                .animation(.easeInOut(duration: 0.6))
                                .scaleEffect(link.connexionStatus == .Connected ? 1.0 : 0.8)
                                .rotationEffect(link.connexionStatus == .Connected ? .zero : .radians(dial.loading * 2 * .pi - .pi * 1/3))
                            ForEach(0..<12) { i in
                                TimeIndicator(.detail)
                                    .transformEffect(.init(translationX: 0, y: (size - 120) / -2))
                                    .rotationEffect(.init(degrees: Double(i * 30)))
                                    .opacity(visibleWhenConnected)
                                    .animation(.linear(duration: 0.1).delay(0.05 * Double(i)))
                            }
                            Circle()
                                .strokeBorder(Color.tCream, lineWidth: 2)
                                .background(Circle().fill(Color.tSoil))
                                .frame(width: 28, height: 28)
                                .transformEffect(.init(translationX: 0, y: (size - 128) / -2))
                                .rotationEffect(handleAngle)
                                .opacity(visibleWhenConnected)
                                .animation(.easeInOut(duration: isDraggingEnabled ? 0.2 : 0.6))
                        }
                        .frame(width: size - 48, height: size - 48)
                        TimeIndicator(.horizontal)
                            .opacity(visibleWhenNotSearching)
                    }
                    .frame(width: size - 48, height: size - 48)
                    TimeIndicator(.vertical)
                        .opacity(visibleWhenNotSearching)
                }
                .frame(width: size, height: size)
                .gesture(rotationDragGesture(diameter: size))
                Spacer()
            }
        }
        .onAppear { withAnimation(dial.loadingAnimation) { dial.loading = 1 } }
    }
    
    private func rotationDragGesture(diameter: CGFloat) -> some Gesture {
        let center = CGPoint(x: diameter/2, y: diameter/2)
        return DragGesture()
            .onChanged { value in
                guard isDraggingEnabled else { return }
                dial.angle = rotationAngle(of: value.location, around: center)
                link.updateTimer(dialValue: dial.angle.radians)
            }
            .onEnded { value in
                guard isDraggingEnabled else { return }
                dial.angle = rotationAngle(of: value.location, around: center)
                link.updateTimer(dialValue: dial.angle.radians, forcing: true)
            }
    }

    private func rotationAngle(of point: CGPoint, around center: CGPoint) -> Angle {
        let deltaY = point.y - center.y
        let deltaX = point.x - center.x
        return Angle(radians: Double(atan2(deltaY, deltaX)))
    }
    
}

struct TimerWheel_Previews: PreviewProvider {
    static var previews: some View {
        TimerWheel()
            .environmentObject(TempoLink())
    }
}
