//
//  TempoLink.swift
//  Tempo (iOS)
//
//  Created by Romain Penchenat on 09/09/2021.
//

import SwiftUI
import Combine

class TempoLink: ObservableObject {
    
    enum ConnexionStatus {
        case Searching, Connecting, Connected
    }
    
    var connexionStatus: ConnexionStatus {
        if objectRepresentation.status == .Available {
            return .Connected
        } else if digitalRepresentation.status == .Available {
            return .Connecting
        } else {
            return .Searching
        }
    }
    var minutesDisplay: Int? { objectRepresentation.status == .Available ? digitalRepresentation.timerDuration : nil }
    @Published var secondsDisplay:Int? = nil
    
    private let finder = TempoFinder()
    
    @Published var digitalRepresentation = TempoDigitalRepresentation()
    var digitalRepresentationCancellable:AnyCancellable? = nil
    @Published var objectRepresentation = TempoObjectRepresentation()
    var objectRepresentationCancellable:AnyCancellable? = nil
    
    private lazy var interface = TempoInterface(digitalRepresentation: digitalRepresentation)
    
    init() {
        finder.delegate = self
        digitalRepresentationCancellable = digitalRepresentation.objectWillChange.sink(receiveValue: { [weak self] (_) in
            self?.objectWillChange.send()
        })
        objectRepresentationCancellable = objectRepresentation.objectWillChange.sink(receiveValue: { [weak self] (_) in
            self?.objectWillChange.send()
        })
    }
    
    func updateTimer(dialValue:Double) {
        let newTimerDuration = Int(dialValue / .pi * 30)
        guard newTimerDuration != digitalRepresentation.timerDuration else { return }
        UIImpactFeedbackGenerator(style: newTimerDuration % 5 == 0 ? .heavy : .light).impactOccurred()
        digitalRepresentation.timerDuration = newTimerDuration
        secondsDisplay = 0
        interface.setTimer(duration: newTimerDuration, handler: objectRepresentation.statusUpdate)
    }
    
    func play() {
        print("Launch")
        digitalRepresentation.activity = .Loading
        interface.launch(handler: objectRepresentation.statusUpdate)
    }
    
    func pause() {
        print("Stop")
        digitalRepresentation.activity = .Waiting
        interface.stop(handler: objectRepresentation.statusUpdate)
//        switch digitalRepresentation.activity {
//        case .Running:
//            print("Pause")
//            digitalRepresentation.activity = .Waiting
//            interface.pause(handler: objectRepresentation.statusUpdate)
//        case .Waiting:
//            print("Stop")
//            digitalRepresentation.activity = .Waiting
//            interface.stop(handler: objectRepresentation.statusUpdate)
//        default:
//            break
//        }
    }
    
}

extension TempoLink : TempoFinderDelegate {
    
    func didFindTempo(ip:String) {
        print("did find tempo")
        DispatchQueue.main.asyncWithAnimation {
            self.digitalRepresentation.setUp(ip: ip)
        }
        interface.getObjectState { result in
            switch result {
            case .success(let status):
                DispatchQueue.main.asyncWithAnimation {
                    self.objectRepresentation.setUp(ip: ip)
                    self.digitalRepresentation.timerDuration = status.timerDuration
                    self.secondsDisplay = 0
                }
            case .failure(let error):
                print("Fail : \(error.localizedDescription)")
                DispatchQueue.main.asyncWithAnimation {
                    self.digitalRepresentation.ip = nil
                    self.digitalRepresentation.status = .NotFound
                }
                self.tempoNotFound()
            }
        }
    }
    
    func tempoNotFound() {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1, execute: finder.lookForTempo)
    }
    
}
