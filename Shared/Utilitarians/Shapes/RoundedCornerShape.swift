//
//  RoundedCornerShape.swift
//  Tempo (iOS)
//
//  Created by Romain Penchenat on 09/09/2021.
//

import SwiftUI

struct RoundedCornersShape: Shape {
    #if os(iOS)
    let corners: UIRectCorner
    #endif
    let radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        #if os(iOS)
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        #else
        let path = NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius)
        #endif
        return Path(path.cgPath)
    }
}
