//
//  ArcCircle.swift
//  Tempo (iOS)
//
//  Created by Romain Penchenat on 10/09/2021.
//

import SwiftUI

struct ArcCircle: Shape {
    let start: CGFloat
    var end: CGFloat
    
    var animatableData: CGFloat {
        get { end }
        set { self.end = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.origin.x + rect.width / 2, y: rect.origin.y + rect.height / 2)
        let radius = min(rect.width, rect.height) / 2
        let startRadian = start * .pi * 2 - (.pi * 0.5)
        let endRadian = end * .pi * 2 - (.pi * 0.5)
        #if os(iOS)
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startRadian, endAngle: endRadian, clockwise: true)
        path.addLine(to: center)
        #else
        let path = NSBezierPath()
        path.move(to: center)
        path.line(to: center)
        path.appendArc(withCenter: center, radius: radius, startAngle: start * 360, endAngle: end * 360)
        path.line(to: center)
        #endif
        return Path(path.cgPath)
    }
}

struct ArcCircle_Previews: PreviewProvider {
    
    static var previews: some View {
        ArcCircle(start: 0, end: 0.6)
            .fill(Color.red)
            .frame(width: 100, height: 100, alignment: .center)
            .background(Color.blue)
    }
}
