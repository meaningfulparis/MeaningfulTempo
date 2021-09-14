//
//  TempoRepresentation.swift
//  Tempo
//
//  Created by Romain Penchenat on 10/09/2021.
//

import Foundation

class TempoObjectRepresentation: TempoRepresentation {
    
    func statusUpdate(_ result:Result<TempoInterface.Response.Default, TempoInterface.InterfaceError>) {
        switch result {
        case .success(let resp):
            DispatchQueue.main.async {
                self.status = .Available
                self.activity = resp.activity
                self.timerDuration = resp.timerDuration
                self.timerStart = Date(timeIntervalSinceNow: resp.timerRelativeStart / -1000)
            }
        case .failure(let error):
            DispatchQueue.main.async {
                if self.status == .Lost {
                    self.status = .NotFound
                } else {
                    self.status = .Lost
                }
            }
            print("Error : \(error.localizedDescription)")
        }
    }
    
}

class TempoDigitalRepresentation: TempoRepresentation {
    
    @Published var currentTime:Date = Date()
    
    var remainingTime: TimeInterval? {
        guard let timerEnd = timerEnd else { return nil }
        return Date().distance(to: timerEnd)
    }
    
    private var timer:Timer?
    
    override init() {
        super.init()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: self.timerAction)
    }
    
    func timerAction(_ timer:Timer) {
        guard self.viewMode == .RunningTimer else { return }
        DispatchQueue.main.asyncWithAnimation {
            self.currentTime = Date()
        }
    }
    
    func synchronizeTo(object:TempoObjectRepresentation) {
        DispatchQueue.main.async {
            self.status = object.status
            self.activity = object.activity
            self.timerDuration = object.timerDuration
            self.timerStart = object.timerStart
        }
    }
    
}

class TempoRepresentation:ObservableObject {
    
    enum Status { case NotFound, Available, Lost }
    enum ViewMode {
        case Settings, RunningTimer, PausedTimer
    }
    enum Activity:Int, Codable {
        case Off, Waiting, Loading, Running, RunEnding, RunOffseting
    }
    
    let port:String = "8000"
    var ip:String? = nil
    
    @Published var status:Status = .NotFound
    @Published var activity:Activity = .Waiting
    var viewMode: ViewMode {
        if [Activity.Off, Activity.Waiting].contains(activity) {
            return .Settings
        } else {
            return .RunningTimer
        }
    }
    @Published var timerDuration:Int = 15
    @Published var timerStart:Date? = nil
    
    var timerEnd: Date? {
        guard let timerStart = timerStart else { return nil }
        return timerStart.addingTimeInterval( Double(timerDuration) * 60)
    }
    
    func setUp(ip:String) {
        self.ip = ip
        self.status = .Available
    }
    
    func isSynchronizedWith(_ representation:TempoRepresentation) -> Bool {
        return self.status == representation.status
                && self.activity == representation.activity
                && self.timerDuration == representation.timerDuration
                && self.timerStart == representation.timerStart
    }
    
}
