//
//  TempoLink.swift
//  Tempo (iOS)
//
//  Created by Romain Penchenat on 09/09/2021.
//

import SwiftUI

class TempoLink: ObservableObject {
    
    @Published var isConnected:Bool = false
    @Published var minutesDisplay:Int? = nil
    @Published var secondsDisplay:Int? = nil
    
    private lazy var interface = TempoInterface()
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, qos: .userInitiated) {
            withAnimation {
                self.isConnected = true
                self.minutesDisplay = 15
                self.secondsDisplay = 0
            }
        }
    }
    
    func updateTimer(dialValue:Double) {
        minutesDisplay = Int(dialValue / .pi * 30)
        secondsDisplay = 0
        if let minutes = minutesDisplay {
            _ = interface.setTimer(duration: minutes)
        }
    }
    
    func play() {
        print("play")
    }
    
}
