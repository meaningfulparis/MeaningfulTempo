//
//  TempoInterface.swift
//  Tempo (iOS)
//
//  Created by Romain Penchenat on 10/09/2021.
//

import Foundation

class TempoInterface {
    
    struct State {
        let isRunning:Bool
        let timerDuration:Int
        let timerProgression:Int
    }
    
    func getObjectState() -> State {
        return State(isRunning: true, timerDuration: 30, timerProgression: 10)
    }
    
    func setTimer(duration:Int) -> Bool {
        return true
    }
    
    func launch() -> Bool {
        return true
    }
    
    func pause() -> Bool {
        return true
    }
    
    func stop() -> Bool {
        return true
    }
    
}
