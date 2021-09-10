//
//  TimerWheel.swift
//  Tempo (iOS)
//
//  Created by Romain Penchenat on 09/09/2021.
//

import SwiftUI

struct TimerWheel: View {
    
    struct Dial {
        
        init(defaultValue: Double? = nil) {
            if let val = defaultValue {
                _angle = Angle(radians: val)
            }
        }
        
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
        private var _angle:Angle = .zero
        var loading: Double = 0
        let loadingAnimation = Animation.easeInOut(duration: 10).repeatForever()
        
    }
    
    @EnvironmentObject var link:TempoLink
    
    @State private var dial = Dial(defaultValue: .pi / 2)
    
    var body: some View {
        GeometryReader { g in
            VStack(alignment: .center, spacing: 8) {
                TimeIndicator(.vertical)
                    .opacity(link.isConnected ? 1 : 0)
                HStack(alignment: .center, spacing: 8) {
                    TimeIndicator(.horizontal)
                        .opacity(link.isConnected ? 1 : 0)
                    ZStack(alignment: .center) {
                        TempoButton()
                            .animation(.easeInOut(duration: 0.6))
                            .scaleEffect(link.isConnected ? 1.0 : 0.8)
                            .rotationEffect(link.isConnected ? .zero : .radians(dial.loading * 2 * .pi - .pi * 1/3))
                        ForEach(0..<12) { i in
                            TimeIndicator(.detail)
                                .transformEffect(.init(translationX: 0, y: (g.size.width - 120) / -2))
                                .rotationEffect(.init(degrees: Double(i * 30)))
                                .opacity(link.isConnected ? 1 : 0)
                                .animation(.linear(duration: 0.1).delay(0.05 * Double(i)))
                        }
                        Circle()
                            .strokeBorder(Color.tCream, lineWidth: 2)
                            .background(Circle().fill(Color.tSoil))
                            .frame(width: 28, height: 28)
                            .transformEffect(.init(translationX: 0, y: (g.size.width - 128) / -2))
                            .rotationEffect(.init(radians: link.isConnected ? dial.angle.radians : 0))
                            .opacity(link.isConnected ? 1 : 0)
                            .animation(.easeInOut(duration: 0.6))
                    }
                    .frame(width: g.size.width - 48, height: g.size.width - 48)
                    TimeIndicator(.horizontal)
                        .opacity(link.isConnected ? 1 : 0)
                }
                .frame(width: g.size.width - 48, height: g.size.width - 48)
                TimeIndicator(.vertical)
                    .opacity(link.isConnected ? 1 : 0)
            }
            .frame(width: g.size.width, height: g.size.width)
            .gesture(rotationDragGesture(diameter: g.size.width))
        }
        .onAppear { withAnimation(dial.loadingAnimation) { dial.loading = 1 } }
        .padding(.bottom, 40)
    }
    
    private func rotationDragGesture(diameter: CGFloat) -> some Gesture {
        let center = CGPoint(x: diameter/2, y: diameter/2)
        return DragGesture()
            .onChanged { value in
                dial.angle = rotationAngle(of: value.location, around: center)
                link.updateTimer(dialValue: dial.angle.radians)
            }
            .onEnded { _ in
                link.updateTimer(dialValue: dial.angle.radians)
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
