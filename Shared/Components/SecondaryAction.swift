//
//  SecondaryAction.swift
//  Tempo
//
//  Created by Romain Penchenat on 15/09/2021.
//

import SwiftUI

struct SecondaryAction: View {
    
    @EnvironmentObject var link:TempoLink
    
    var body: some View {
        Button(action: buttonAction, label: {
            HStack(alignment: .center, spacing: 8) {
                Image("PlayButton")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundColor(.tSoil)
                Text("Relancer")
                    .modifier(HighlightText(color: .tSoil))
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 32)
        })
        .disabled(link.viewMode != .RunningTimer)
        .opacity(link.viewMode == .RunningTimer ? 1 : 0)
    }
    
    private func buttonAction() {
        link.pause()
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 0.5, execute: link.play)
    }
    
}

struct SecondaryAction_Previews: PreviewProvider {
    static var previews: some View {
        SecondaryAction()
            .environmentObject(TempoLink())
    }
}
