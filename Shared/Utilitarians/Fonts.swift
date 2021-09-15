//
//  Fonts.swift
//  Tempo
//
//  Created by Romain Penchenat on 15/09/2021.
//

import SwiftUI

struct HighlightText: ViewModifier {
    
    var color:Color = .tBlack
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Sora-SemiBold", size: 14))
            .foregroundColor(color)
    }
    
}

struct TimerText: ViewModifier {
    
    var color:Color = .tBlack
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Sora-Regular", size: 60))
            .foregroundColor(color)
    }
    
}

struct SmallTimerText: ViewModifier {
    
    var color:Color = .tBlack
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Sora-Regular", size: 32))
            .foregroundColor(color)
    }
    
}

struct DetailText: ViewModifier {
    
    var color:Color = .tSoil
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Sora-Regular", size: 14))
            .foregroundColor(color)
    }
    
}

struct Fonts_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("HighlightText")
                .modifier(HighlightText())
            Text("TimerText")
                .modifier(TimerText())
            Text("SmallTimerText +")
                .modifier(SmallTimerText())
            Text("DetailText")
                .modifier(DetailText())
        }
    }
}
