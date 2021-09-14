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
    private lazy var interface = TempoInterface(representation: digitalRepresentation)
    
    init() {
        finder.delegate = self
    }
    
    func updateTimer(dialValue:Double) {
        let newTimerDuration = Int(dialValue / .pi * 30)
        guard newTimerDuration != digitalRepresentation.timerDuration else { return }
        UIImpactFeedbackGenerator(style: newTimerDuration % 5 == 0 ? .heavy : .light).impactOccurred()
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
        interface.getObjectState { result in
            switch result {
            case .success(let status):
                self.objectRepresentation.setUp(ip: ip)
                DispatchQueue.main.async {
                    withAnimation {
                        self.digitalRepresentation.timerDuration = status.timerDuration
                        self.secondsDisplay = 0
                    }
                }
            case .failure(let error):
                print("Fail : \(error.localizedDescription)")
                self.digitalRepresentation.ip = nil
                self.tempoNotFound()
            }
        }
    }
    
    func tempoNotFound() {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1, execute: finder.lookForTempo)
    }
    
}
