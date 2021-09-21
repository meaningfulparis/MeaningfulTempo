//
//  ErrorToast.swift
//  Tempo
//
//  Created by Romain Penchenat on 21/09/2021.
//

import SwiftUI

struct ErrorToast: View {
    
    var error:TempoConfigurator.WiFiNetworkErrorDescription
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(error.title)
                    .modifier(DetailText(color: .tBlack))
                Text(error.details)
                    .modifier(DetailText())
            }
            Spacer()
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 16)
        .background(Color.tSand)
        .cornerRadius(16)
        .padding(.all, 16)
    }
}

struct ErrorToast_Previews: PreviewProvider {
    static var previews: some View {
        ErrorToast(error: TempoConfigurator.WiFiNetworkErrorDescription(title: "Titre de l'erreur", details: "Pensez à redémarrer votre réfrigirateur."))
    }
}
