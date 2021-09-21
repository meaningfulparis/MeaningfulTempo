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
    
    @Published var knownWiFiNetworks:[WiFiNetwork] = []
    @Published var destinationNetwork:String? = nil
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
        interface.trashWiFiNetwork(ssid: ssid) { result in
            switch result {
                case .success(let resp):
                    if resp.success {
                        DispatchQueue.main.asyncWithAnimation {
                            self.knownWiFiNetworks.removeAll { $0.ssid == ssid }
                        }
                    } else {
                        print("Failed to remove")
                        #warning("Error to manage")
                    }
                    break
                case .failure(let error):
                    print("Error while trashing WiFi : \(error)")
                    break
            }
        }
    }
    
    func connectToWiFi(called ssid:String, withPassword password:String = "") {
        print("Connect to \(ssid) with \(password)")
        interface.transferWiFiNetwork(ssid: ssid, password: password) { result in
            switch result {
                case .success(let resp):
                    if resp.success {
                        DispatchQueue.main.asyncWithAnimation {
                            self.destinationNetwork = ssid
                        }
                    } else {
                        print("Too much data or no more space...")
                        #warning("Error to manage")
                    }
                    break
                case .failure(let error):
                    print("Error while connecting to WiFi : \(error)")
                    break
            }
        }
    }
    
}
