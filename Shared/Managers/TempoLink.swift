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
    var viewMode: TempoDigitalRepresentation.ViewMode { digitalRepresentation.viewMode }
    var activity: TempoRepresentation.Activity { digitalRepresentation.activity }
    var minutesDisplay: Int? {
        guard objectRepresentation.status == .Available else { return nil }
        switch objectRepresentation.viewMode {
        case .Settings:
            return digitalRepresentation.timerDuration
        default:
            guard let remainingTime = digitalRepresentation.remainingTime else {
                return digitalRepresentation.timerDuration
            }
            return Int(floor(remainingTime / 60))
        }
    }
    var secondsDisplay: Int? {
        guard objectRepresentation.status == .Available else { return nil }
        switch objectRepresentation.viewMode {
        case .Settings:
            return 0
        default:
            guard let remainingTime = digitalRepresentation.remainingTime else {
                return 0
            }
            return Int(remainingTime.truncatingRemainder(dividingBy: 60))
        }
    }
    
    private let finder = TempoFinder()
    
    @Published private var objectRepresentation = TempoObjectRepresentation()
    private var objectRepresentationCancellable:AnyCancellable? = nil
    @Published private var digitalRepresentation = TempoDigitalRepresentation()
    private var digitalRepresentationCancellable:AnyCancellable? = nil
    
    private lazy var interface = TempoInterface(digitalRepresentation: digitalRepresentation)
    
    init() {
        finder.delegate = self
        objectRepresentationCancellable = objectRepresentation.objectWillChange.sink(receiveValue: { [weak self] (_) in
            self?.objectWillChange.send()
        })
        digitalRepresentationCancellable = digitalRepresentation.objectWillChange.sink(receiveValue: { [weak self] (_) in
            self?.objectWillChange.send()
        })
    }
    
    func updateTimer(dialValue:Double) {
        let newTimerDuration = Int(dialValue / .pi * 30)
        guard newTimerDuration != digitalRepresentation.timerDuration else { return }
        UIImpactFeedbackGenerator(style: newTimerDuration % 5 == 0 ? .heavy : .light).impactOccurred()
        digitalRepresentation.timerDuration = newTimerDuration
        interface.setTimer(duration: newTimerDuration, handler: objectRepresentation.statusUpdate)
    }
    
    func play() {
        print("Launch")
        digitalRepresentation.timerStart = nil
        digitalRepresentation.activity = .Loading
        interface.launch(duration: digitalRepresentation.timerDuration) { result in
            self.objectRepresentation.statusUpdate(result)
            self.digitalRepresentation.synchronizeTo(object: self.objectRepresentation)
        }
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
            case .success(_):
                DispatchQueue.main.asyncWithAnimation {
                    self.objectRepresentation.setUp(ip: ip)
                    self.objectRepresentation.statusUpdate(result)
                    self.digitalRepresentation.synchronizeTo(object: self.objectRepresentation)
                }
            case .failure(let error):
                print("Fail : \(error.localizedDescription)")
                DispatchQueue.main.asyncWithAnimation {
                    self.digitalRepresentation.synchronizeTo(object: self.objectRepresentation)
                }
                self.tempoNotFound()
            }
        }
    }
    
    func tempoNotFound() {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1, execute: finder.lookForTempo)
    }
    
}
