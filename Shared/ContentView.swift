//
//  ContentView.swift
//  Shared
//
//  Created by Romain Penchenat on 09/09/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Header()
            TimerDisplay()
            TimerWheel()
            SecondaryAction()
        }
        .padding(.bottom, 40)
        .background(Color.tCream.edgesIgnoringSafeArea(.all))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(TempoLink())
    }
}
