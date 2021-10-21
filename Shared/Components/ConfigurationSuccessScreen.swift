//
//  ConfigurationSuccessScreen.swift
//  Tempo
//
//  Created by Romain Penchenat on 17/09/2021.
//

import SwiftUI

struct ConfigurationSuccessScreen: View {
    
    @EnvironmentObject var link:TempoLink
    @Binding var ssid:String?
    
    var body: some View {
        VStack(alignment: .center, spacing: 40) {
            Image("TempoIllustration")
            VStack(spacing: 8) {
                Text("Tempo tente de rejoindre le WiFi \"\(ssid ?? "")\"")
                    .modifier(HighlightText())
                Text("Partez à sa rencontre tout de suite en vous connectant également au WiFi \"\(ssid ?? "")\".")
                    .modifier(DetailText())
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, 24)
            Button(action: restart) {
                Text("J’ai rejoins Tempo")
                    .modifier(HighlightText(color: .tBlue))
                    .padding(.all, 24)
                    .background(Color.tWhite)
                    .cornerRadius(24)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    private func restart() {
        link.restart()
        ssid = nil
    }
    
}

struct ConfigurationSuccessScreen_Previews: PreviewProvider {
    
    @State static var ssid:String? = "Meaningful"
    
    static var previews: some View {
        ConfigurationSuccessScreen(ssid: $ssid)
            .padding(.vertical, 100)
            .background(Color.tCream.edgesIgnoringSafeArea(.all))
    }
}
