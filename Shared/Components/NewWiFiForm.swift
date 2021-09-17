//
//  NewWiFiForm.swift
//  Tempo
//
//  Created by Romain Penchenat on 17/09/2021.
//

import SwiftUI

struct NewWiFiForm: View {
    
    @State var isOpen:Bool = false
    @State private var name:String = ""
    @State private var password:String = ""
    
    var connectAction:(String, String) -> Void
    
    
    var body: some View {
        VStack {
            HStack {
                Text("Ajouter un réseau WiFi")
                    .foregroundColor(isOpen ? .tBlack : .tBlue)
                    .modifier(DetailText(color: .tBlue))
                    .padding(.leading, 8)
                Spacer()
                Image("PlusIcon")
                    .resizable()
                    .frame(width: 45, height: 45)
                    .foregroundColor(isOpen ? .tBlack : .tBlue)
                    .rotationEffect(isOpen ? .degrees(45) : .zero)
            }
            .onTapGesture {
                withAnimation {
                    isOpen.toggle()
                }
            }
            if isOpen {
                VStack(alignment: .center, spacing: 16) {
                    InputField(label: "Nom du réseau", value: $name)
                    InputField(label: "Mot de passe", value: $password, securedTextField: false)
                    Button(action: addNewWiFiNetwork, label: {
                        Text("Connexion")
                            .modifier(HighlightText(color: .tBlue))
                            .padding(.vertical, 8)
                    })
                }
            }
        }
        .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
        .background(Color.tWhite)
        .cornerRadius(24)
    }
    
    private func addNewWiFiNetwork() {
        guard name.count > 0 else { return }
        guard password.count > 0 else { return }
        connectAction(name, password)
    }
    
}

struct NewWiFiForm_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NewWiFiForm { (ssid, password) in
                print("Connect to \(ssid) with \(password)")
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 100)
        .background(Color.tCream)
    }
}
