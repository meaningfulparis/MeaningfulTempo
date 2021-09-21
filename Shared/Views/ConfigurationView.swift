//
//  ConfigurationView.swift
//  Tempo
//
//  Created by Romain Penchenat on 17/09/2021.
//

import SwiftUI

struct ConfigurationView: View {
    
    @StateObject var configurator:TempoConfigurator
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if configurator.destinationNetwork != nil {
                ConfigurationSuccessScreen(ssid: $configurator.destinationNetwork)
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 40) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Invitez Tempo à votre réseau WiFi")
                                .modifier(HighlightText())
                            Text("Si vulnérable et dévoué, ne laissez pas Tempo tout seul ! Donnez lui les clés pour rejoindre vos réseaux WiFi favoris.")
                                .modifier(DetailText())
                        }
                        .padding(.horizontal, 8)
                        VStack(spacing: 16) {
                            if configurator.knownWiFiNetworks.count < 5 {
                                NewWiFiForm(connectAction: { (ssid, password) in configurator.connectToWiFi(called: ssid, withPassword: password)  })
                            }
                            ForEach(configurator.knownWiFiNetworks) { network in
                                WiFiCard(
                                    network: network,
                                    trashAction: configurator.trashWiFi,
                                    connectAction: { (ssid) in configurator.connectToWiFi(called: ssid)  }
                                )
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                }
                .opacity(configurator.isLoading ? 0.5 : 1)
                .disabled(configurator.isLoading)
            }
            if let error = configurator.error {
                ErrorToast(error: error)
                    .transition(.move(edge: .bottom))
            }
        }
    }
    
}

struct ConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigurationView(configurator: TempoConfigurator(interface: TempoInterface(digitalRepresentation: TempoDigitalRepresentation())))
    }
}
