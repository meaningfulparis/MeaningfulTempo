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
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            VStack(spacing: 0) {
                Header()
                Spacer()
                switch link.viewMode {
                case .WifiConfiguration:
                    ConfigurationView(configurator: TempoConfigurator(interface: link.interface))
                default:
                    MainView()
                }
                Spacer()
            }
            .onChange(of: scenePhase) { link.scenePhase = $0 }
            .environmentObject(link)
            .background(Color.tCream.edgesIgnoringSafeArea(.all))
            #if os(macOS)
            .frame(minWidth: 720, minHeight: 720)
            #endif
        }
        #if os(macOS)
        .windowStyle(HiddenTitleBarWindowStyle())
        #endif
    }
}
