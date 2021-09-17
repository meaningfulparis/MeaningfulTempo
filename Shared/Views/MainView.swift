//
//  ContentView.swift
//  Shared
//
//  Created by Romain Penchenat on 09/09/2021.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
            TimerDisplay()
            TimerWheel()
            SecondaryAction()
        }
        .padding(.bottom, 40)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(TempoLink())
    }
}
