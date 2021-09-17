//
//  TempoConfigurator.swift
//  Tempo
//
//  Created by Romain Penchenat on 17/09/2021.
//

import SwiftUI

struct TempoConfigurator {
    
    struct WiFiNetwork:Identifiable {
        let id = UUID()
        let ssid:String
    }
    
    var knownWiFiNetworks:[WiFiNetwork] = []
    var destinationNetwork:String? = nil
    private let interface = TempoWiFiInterface()
    
    init() {
        knownWiFiNetworks = interface.getKnownWiFiNetworks()
    }
    
    func trashWiFi(called ssid:String) {
        print("Trash wifi called \(ssid)")
    }
    
    mutating func connectToWiFi(called ssid:String, withPassword password:String? = nil) {
        print("Connect to \(ssid) with \(password)")
        withAnimation {
            self.destinationNetwork = ssid
        }
    }
    
}
