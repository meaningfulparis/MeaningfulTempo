//
//  TempoApp.swift
//  Shared
//
//  Created by Romain Penchenat on 09/09/2021.
//

import SwiftUI

@main
struct TempoApp: App {
    
    @StateObject var link = TempoLink()
    
    var body: some Scene {
        WindowGroup {
            VStack(spacing: 0) {
                Header()
                Spacer()
                switch link.viewMode {
                case .WifiConfiguration:
                    ConfigurationView()
                default:
                    MainView()
                }
                Spacer()
            }
            .environmentObject(link)
            .background(Color.tCream.edgesIgnoringSafeArea(.all))
        }
    }
}
