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
            ContentView()
                .environmentObject(link)
        }
    }
}
