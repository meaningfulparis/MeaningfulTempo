//
//  TempoRepresentation.swift
//  Tempo
//
//  Created by Romain Penchenat on 10/09/2021.
//

import Foundation

class TempoObjectRepresentation: TempoRepresentation {
    
    func statusUpdate(_ result:Result<TempoInterface.Response.Status?, Error>) {
        switch result {
        case .success(let resp):
            status = .Available
            guard let resp = resp else { return }
            activity = Activity(rawValue: resp.activity) ?? .Waiting
            timerDuration = resp.timerDuration
            timerProgression = resp.timerProgression
            print(resp)
        case .failure(let error):
            if status == .Lost {
                status = .NotFound
            } else {
                status = .Lost
            }
            print("Error : \(error.localizedDescription)")
        }
    }
    
    func classicUpdate(_ result:Result<TempoInterface.Response.Default?, Error>) {
        switch result {
        case .success(let resp):
            print(resp)
            status = .Available
        case .failure(let error):
            print("Error : \(error.localizedDescription)")
        }
    }
    
}

class TempoDigitalRepresentation: TempoRepresentation {
    
    
    
}

class TempoRepresentation:ObservableObject {
    
    enum Status { case NotFound, Available, Lost }
    enum Activity:Int { case Waiting, Running, Paused }
    
    @Published var status:Status = .NotFound
    let port:String = "8000"
    var ip:String? = nil
    var activity:Activity = .Waiting
    @Published var timerDuration:Int = 15
    @Published var timerProgression:Int = 0
    
    func setUp(ip:String) {
        self.ip = ip
        self.status = .Available
    }
    
    func isSynchronizedWith(_ representation:TempoRepresentation) -> Bool {
        return self.status == representation.status
                && self.ip == representation.ip
                && self.activity == representation.activity
                && self.timerDuration == representation.timerDuration
                && self.timerProgression == representation.timerProgression
    }
    
}
