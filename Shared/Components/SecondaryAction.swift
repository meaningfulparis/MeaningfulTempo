//
//  SecondaryAction.swift
//  Tempo
//
//  Created by Romain Penchenat on 15/09/2021.
//

import SwiftUI

struct SecondaryAction: View {
    
    enum UseCase {
        case PlayAgain, Help, None
    }
    
    @EnvironmentObject var link:TempoLink
    
    private var useCase:UseCase {
        if link.viewMode == .RunningTimer {
            return .PlayAgain
        } else if link.connexionStatus == .Searching || link.connexionStatus == .Connecting {
            return .Help
        } else {
            return .None
        }
    }
    
    var body: some View {
        Button(action: buttonAction, label: {
            HStack(alignment: .top, spacing: 8) {
                Image(useCase == .Help ? "HelpIcon" : "PlayButton")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundColor(.tSoil)
                Text(useCase == .Help ? "AIDE" : "RELANCER")
                    .modifier(HighlightText(color: .tSoil))
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 32)
        })
        .buttonStyle(PlainButtonStyle())
        .disabled(useCase == .None)
        .opacity(useCase == .None ? 0 : 1)
        .sheet(isPresented: $link.needHelp) {
            HelpView()
                #if os(macOS)
                .frame(minWidth: 600, idealWidth: 600, maxWidth: 600, minHeight: 600, idealHeight: 600, maxHeight: 600)
                #endif
        }
    }
    
    private func buttonAction() {
        switch useCase {
        case .PlayAgain:
            link.pause()
            DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 0.5, execute: link.play)
        case .Help:
            link.needHelp = true
        default:
            break
        }
    }
    
}

struct SecondaryAction_Previews: PreviewProvider {
    static var previews: some View {
        SecondaryAction()
            .environmentObject(TempoLink())
    }
}
