//
//  Header.swift
//  Tempo (iOS)
//
//  Created by Romain Penchenat on 09/09/2021.
//

import SwiftUI

struct Header: View {
    
    @EnvironmentObject private var link:TempoLink
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    var connexionStatusText: String {
        switch link.connexionStatus {
        case .Connected:
            return "Tempo connecté"
        case .Connecting:
            return "Connexion à Tempo..."
        case .Searching:
            return "Recherche de Tempo..."
        }
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Image("BurgerMenu")
                .frame(width: 44, height: 44)
            Spacer()
            Text(connexionStatusText)
            Spacer()
            (link.connexionStatus == .Connected ? Image("TempoConnected") : Image("TempoNotFound"))
                .frame(width: 44, height: 44)
        }
        .padding(EdgeInsets(top: 8 + safeAreaInsets.top, leading: 24, bottom: 16, trailing: 24))
        .background(
            RoundedCornersShape(corners: [.bottomLeft, .bottomRight], radius: 32)
                .fill(Color.tSand)
        )
        .edgesIgnoringSafeArea(.top)
    }
    
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header()
            .environmentObject(TempoLink())
    }
}
