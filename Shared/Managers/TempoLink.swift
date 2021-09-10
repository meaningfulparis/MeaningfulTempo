//
//  TempoLink.swift
//  Tempo (iOS)
//
//  Created by Romain Penchenat on 09/09/2021.
//

import SwiftUI

class TempoLink: ObservableObject {
    
    var isConnected: Bool { objectRepresentation.status == .Available }
    var minutesDisplay: Int? { digitalRepresentation.status == .Available ? digitalRepresentation.timerDuration : nil }
    @Published var secondsDisplay:Int? = nil
    
    private let finder = TempoFinder()
    private let digitalRepresentation = TempoDigitalRepresentation()
    private let objectRepresentation = TempoObjectRepresentation()
    private lazy var interface = TempoInterface(representation: objectRepresentation)
    
    init() {
        finder.delegate = self
    }
    
    func updateTimer(dialValue:Double) {
        let newTimerDuration = Int(dialValue / .pi * 30)
        guard newTimerDuration != digitalRepresentation.timerDuration else { return }
        digitalRepresentation.timerDuration = newTimerDuration
        secondsDisplay = 0
        interface.setTimer(duration: newTimerDuration, handler: objectRepresentation.classicUpdate)
    }
    
    func play() {
        print("Launch")
        digitalRepresentation.activity = .Running
        interface.launch(handler: objectRepresentation.classicUpdate)
    }
    
    func pause() {
        switch digitalRepresentation.activity {
        case .Running:
            print("Pause")
            digitalRepresentation.activity = .Paused
            interface.pause(handler: objectRepresentation.classicUpdate)
        case .Paused:
            print("Stop")
            digitalRepresentation.activity = .Running
            interface.stop(handler: objectRepresentation.classicUpdate)
        default:
            break
        }
    }
    
}

extension TempoLink : TempoFinderDelegate {
    
    func didFindTempo(ip:String) {
        digitalRepresentation.setUp(ip: ip)
        objectRepresentation.setUp(ip: ip)
        DispatchQueue.main.async {
            withAnimation {
                self.digitalRepresentation.timerDuration = 15
                self.secondsDisplay = 0
            }
        }
    }
    
    func tempoNotFound() {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1, execute: finder.lookForTempo)
    }
    
}
