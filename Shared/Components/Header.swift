//
//  Header.swift
//  Tempo (iOS)
//
//  Created by Romain Penchenat on 09/09/2021.
//

import SwiftUI

struct Header: View {
    
    @EnvironmentObject private var link:TempoLink
    #if os(iOS)
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    private var topMargin: CGFloat { safeAreaInsets.top }
    #else
    private var topMargin:CGFloat = 32
    #endif
    
    var connexionStatusText: String {
        switch link.connexionStatus {
        case .Connected:
            return "Tempo connecté"
        case .Connecting:
            return "Connexion à Tempo..."
        case .Searching:
            if link.viewMode == .WifiConfiguration {
                return "Paramètrage de Tempo"
            } else {
                return "Recherche de Tempo..."
            }
        }
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Image("SettingsIcon")
                .frame(width: 44, height: 44)
            Spacer()
            Text(connexionStatusText)
                .modifier(HighlightText())
            Spacer()
            (link.connexionStatus == .Connected ? Image("TempoConnected") : Image("TempoNotFound"))
                .frame(width: 44, height: 44)
        }
        .padding(EdgeInsets(top: 8 + topMargin, leading: 24, bottom: 16, trailing: 24))
        .background(backgroundShape)
        .edgesIgnoringSafeArea(.top)
    }
    
    private var backgroundShape: some View {
        #if os(iOS)
        RoundedCornersShape(corners: [.bottomLeft, .bottomRight], radius: 32)
            .fill(Color.tSand)
        #else
        RoundedCornersShape(radius: 32)
            .fill(Color.tSand)
        #endif
    }
    
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header()
            .environmentObject(TempoLink())
    }
}
