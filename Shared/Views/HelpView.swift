//
//  HelpView.swift
//  Tempo
//
//  Created by Romain Penchenat on 17/09/2021.
//

import SwiftUI

struct HelpView: View {
    
    @EnvironmentObject var link:TempoLink
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Vous avez perdu Tempo ?")
                    .modifier(HighlightText())
                Spacer()
                Button(action: { link.needHelp = false }) {
                    Image("CloseIcon")
                        .resizable()
                        .frame(width: 45, height: 45)
                        .foregroundColor(.tBlack)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(EdgeInsets(top: 24, leading: 24, bottom: 24, trailing: 16))
            .background(Color.tSand)
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 40) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Paramétrer Tempo").modifier(HighlightText())
                        Text("1. Connectez-vous au réseau WiFi ouvert nommé “TempoConfiguration”.").modifier(DetailText())
                        Text("2. Ouvrez l’app Tempo.").modifier(DetailText())
                        Text("3. Transmettez les identifiants de votre réseau Wifi à votre Tempo.").modifier(DetailText())
                    }
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Régler les problèmes de connexion").modifier(HighlightText())
                        Text("- Vérifiez que votre appareil est bien connecté sur le même réseau WiFi que Tempo.").modifier(DetailText())
                        Text("- Vérifiez que Tempo est correctement branché.").modifier(DetailText())
                        Text("- Redémarrez Tempo en appuyant 10s sur le bouton principal.").modifier(DetailText())
                    }
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Assistance technique").modifier(HighlightText())
                        Text("Oupsi, doupsi ! Me fâchez pas svp...").modifier(DetailText())
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 40)
            }
        }
        .background(Color.tCream.edgesIgnoringSafeArea(.all))
    }
    
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
