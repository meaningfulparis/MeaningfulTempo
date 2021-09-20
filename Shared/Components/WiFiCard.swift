//
//  WiFiCard.swift
//  Tempo
//
//  Created by Romain Penchenat on 17/09/2021.
//

import SwiftUI

struct WiFiCard: View {
    
    var wifiName:String
    @State var showTrashConfirmation:Bool = false
    var trashAction:(String) -> Void
    var connectAction:(String) -> Void
    
    var body: some View {
        HStack {
            Text(wifiName)
                .modifier(DetailText(color: .tBlack))
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
                    title: Text("Oublier le réseau \(wifiName) ?"),
                    buttons: [
                        .default(Text("Oublier le réseau"), action: {
                            trashAction(wifiName)
                        }),
                        .cancel(Text("Annuler"))
                    ]
                )
            })
            #endif
        }
        .padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 16))
        .background(Color.tWhite)
        .cornerRadius(24)
//        .onTapGesture {
//            connectAction(wifiName, nil)
//        }
    }
}

struct WiFiCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WiFiCard(wifiName: "Meaningful", trashAction: { _ in }, connectAction: { _  in })
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 100)
        .background(Color.tCream)
    }
}
