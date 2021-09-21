//
//  WiFiCard.swift
//  Tempo
//
//  Created by Romain Penchenat on 17/09/2021.
//

import SwiftUI

struct WiFiCard: View {
    
    var network:TempoConfigurator.WiFiNetwork
    @State var showTrashConfirmation:Bool = false
    var trashAction:(String) -> Void
    var connectAction:(String) -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(network.ssid)
                    .modifier(DetailText(color: .tBlack))
                Text(network.pass)
                    .modifier(DetailText())
            }
            Spacer()
            #if os(iOS)
            Button(action: { showTrashConfirmation = true }) {
                Image("TrashIcon")
                    .resizable()
                    .frame(width: 45, height: 45)
                    .foregroundColor(.tBlack)
            }
            .actionSheet(isPresented: $showTrashConfirmation, content: {
                ActionSheet(
                    title: Text("Oublier le réseau \(network.ssid) ?"),
                    buttons: [
                        .default(Text("Oublier le réseau"), action: {
                            trashAction(network.ssid)
                        }),
                        .cancel(Text("Annuler"))
                    ]
                )
            })
            #endif
        }
        .padding(EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 16))
        .background(Color.tWhite)
        .cornerRadius(24)
        .contextMenu {
            Button(action: { trashAction(network.ssid) }) {
                Text("Oublier le réseau")
            }
        }
//        .onTapGesture {
//            connectAction(wifiName, nil)
//        }
    }
}

struct WiFiCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WiFiCard(network: TempoConfigurator.WiFiNetwork(ssid: "Meaningful", pass: "Meaningful_"), trashAction: { _ in }, connectAction: { _  in })
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 100)
        .background(Color.tCream)
    }
}
