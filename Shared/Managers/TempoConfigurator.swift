//
//  TempoConfigurator.swift
//  Tempo
//
//  Created by Romain Penchenat on 17/09/2021.
//

import SwiftUI

class TempoConfigurator : ObservableObject {
    
    struct WiFiNetwork:Identifiable, Decodable {
        let id = UUID()
        let ssid:String
        let pass:String
    }
    
    struct WiFiNetworkErrorDescription {
        let title:String
        let details:String
    }
    
    @Published var knownWiFiNetworks:[WiFiNetwork] = []
    @Published var destinationNetwork:String? = nil
    @Published var isLoading:Bool = false
    @Published var error:WiFiNetworkErrorDescription? = nil
    var interface:TempoInterface
    
    init(interface tempoInterface:TempoInterface) {
        interface = tempoInterface
        interface.getKnownWiFiNetworks { result in
            switch result {
            case .success(let networks):
                DispatchQueue.main.asyncWithAnimation {
                    self.knownWiFiNetworks = networks
                }
            case .failure(let error):
                print("Error while fetching wifi networks : \(error)")
            }
        }
    }
    
    func trashWiFi(called ssid:String) {
        print("Trash wifi called \(ssid)")
        isLoading = true
        interface.trashWiFiNetwork(ssid: ssid) { result in
            switch result {
                case .success(let resp):
                    guard resp.success else {
                        self.showError("Échec de l'oublie du réseau", withDetails: "Veuillez réessayer plus tard.")
                        return
                    }
                    DispatchQueue.main.asyncWithAnimation {
                        self.knownWiFiNetworks.removeAll { $0.ssid == ssid }
                        self.isLoading = false
                    }
                    break
                case .failure(let error):
                    self.showError("Échec de l'oublie du réseau", withDetails: error.localizedDescription)
                    break
            }
        }
    }
    
    func connectToWiFi(called ssid:String, withPassword password:String = "") {
        print("Connect to \(ssid) with \(password)")
        isLoading = true
        interface.transferWiFiNetwork(ssid: ssid, password: password) { result in
            switch result {
                case .success(let resp):
                    guard resp.success else {
                        self.showError("Impossible d'ajouter ce réseau WiFi", withDetails: "Tempo ne peut pas sauvegarder des réseaux WiFi dont les identifiants pésent plus de 50 bits. Réduisez le nom ou le mot de passe du réseau.")
                        return
                    }
                    DispatchQueue.main.asyncWithAnimation {
                        self.destinationNetwork = ssid
                        self.isLoading = false
                    }
                    break
                case .failure(let error):
                    self.showError("Erreur de connexion au réseau WiFi", withDetails: error.localizedDescription)
                    break
            }
        }
    }
    
    private func showError(_ error:String, withDetails details:String) {
        DispatchQueue.main.asyncWithAnimation {
            self.error = WiFiNetworkErrorDescription(title: error, details: details)
            self.isLoading = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { withAnimation {
                self.error = nil
            } }
        }
    }
    
}
