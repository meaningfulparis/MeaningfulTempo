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
    private var padding: EdgeInsets {
        return EdgeInsets(top: 8 + safeAreaInsets.top, leading: 24, bottom: 16, trailing: 24)
    }
    private var margin = EdgeInsets()
    #else
    private var padding = EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24)
    private var margin = EdgeInsets(top: 40, leading: 16, bottom: 0, trailing: 16)
    #endif
    
    private var connexionStatusText: String {
        if link.viewMode == .WifiConfiguration {
            return "Paramètrage de Tempo"
        }
        switch link.connexionStatus {
        case .Connected:
            return "Tempo connecté"
        case .Connecting:
            return "Connexion à Tempo..."
        case .Searching:
            return "Recherche de Tempo..."
        }
    }
    private var batteryStatus: String? {
        guard let battery = link.battery else {
            return nil
        }
        return "\(battery)% de batterie"
    }
    
    private var settingsAreAvailable: Bool {
        link.connexionStatus == .Connected && [.Settings, .WifiConfiguration].contains(link.viewMode)
    }
    
    
    var body: some View {
        HStack(alignment: .center) {
            Button(action: { withAnimation { link.needConfiguration.toggle()} }) {
                Image("SettingsIcon")
                    .frame(width: 44, height: 44)
                    .rotationEffect(link.viewMode == .WifiConfiguration ? .degrees(-90) : .zero)
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(!settingsAreAvailable)
            .opacity(settingsAreAvailable ? 1 : 0.5)
            Spacer()
            VStack(alignment: .center, spacing: 4) {
                Text(connexionStatusText)
                    .modifier(HighlightText())
                if let batteryStatus = batteryStatus {
                    Text(batteryStatus)
                        .modifier(DetailText())
                }
            }
            .animation(.none)
            Spacer()
            (link.connexionStatus == .Connected ? Image("TempoConnected") : Image("TempoNotFound"))
                .frame(width: 44, height: 44)
        }
        .padding(padding)
        .background(backgroundShape)
        .padding(margin)
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
