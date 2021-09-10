//
//  TempoInterface.swift
//  Tempo (iOS)
//
//  Created by Romain Penchenat on 10/09/2021.
//

import Foundation

class TempoInterface {
    
    private let representation:TempoRepresentation
    
    init(representation:TempoRepresentation) {
        self.representation = representation
    }
    
    struct Response {
        struct Default:Decodable {
            let success:Bool
            let device:String
            let message:String
        }
        struct Status:Decodable {
            let activity:Int
            let timerDuration:Int
            let timerProgression:Int
        }
    }
    
    func getObjectState(handler:@escaping (Result<Response.Status?, Error>) -> Void) {
        sendRequest(endpoint: "getObjectState", data: [], handler: handler)
    }
    
    func setTimer(duration:Int, handler:@escaping (Result<Response.Default?, Error>) -> Void) {
        sendRequest(endpoint: "set-timer", data: [String(duration)], handler: handler)
    }
    
    func launch(handler:@escaping (Result<Response.Default?, Error>) -> Void) {
        sendRequest(endpoint: "launch", data: [], handler: handler)
    }
    
    func pause(handler:@escaping (Result<Response.Default?, Error>) -> Void) {
        sendRequest(endpoint: "pause", data: [], handler: handler)
    }
    
    func stop(handler:@escaping (Result<Response.Default?, Error>) -> Void) {
        sendRequest(endpoint: "stop", data: [], handler: handler)
    }
    
    private func sendRequest<T:Decodable>(endpoint:String, data:[String], handler:@escaping (Result<T?, Error>) -> Void) {
        guard let ip = representation.ip else { return }
        guard let url = URL(string: "http://\(ip):\(representation.port)/\(endpoint)/\(data.joined(separator: ":"))") else { return }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, resp, error in
            if let error = error {
                handler(.failure(error))
                return
            }
            guard
                let data = data,
                let result = try? JSONDecoder().decode(T.self, from: data)
                else {
                    handler(.success(nil))
                    return
                }
            handler(.success(result))
            return
        }.resume()
    }
    
}
