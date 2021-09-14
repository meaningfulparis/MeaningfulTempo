//
//  TempoInterface.swift
//  Tempo (iOS)
//
//  Created by Romain Penchenat on 10/09/2021.
//

import Foundation

class TempoInterface {
    
    struct Response {
        struct Default:Codable {
            let success:Bool
            let device:String
            let message:String
        }
        struct Status:Codable {
            let activity:Int
            let timerDuration:Int
            let timerProgression:Int
        }
    }
    
    enum Method:String {
        case GET, PUT
    }
    
    enum InterfaceError:Error {
        case requestFailed, emptyAnswer, jsonDecodingFailed
    }
    
    private let representation:TempoRepresentation
    private var scheduledRequests:[String:DispatchTime] = [:]
    
    init(representation:TempoRepresentation) {
        self.representation = representation
    }
    
    func getObjectState(handler:@escaping (Result<Response.Status, InterfaceError>) -> Void) {
        sendRequest(endpoint: "object-state", method: .GET, data: [], handler: handler)
    }
    
    func setTimer(duration:Int, handler:@escaping (Result<Response.Default, InterfaceError>) -> Void) {
        scheduleRequest(endpoint: "set-timer", method: .PUT, data: [String(duration)], handler: handler)
    }
    
    func launch(handler:@escaping (Result<Response.Default, InterfaceError>) -> Void) {
        sendRequest(endpoint: "launch", method: .PUT, data: [], handler: handler)
    }
    
    func pause(handler:@escaping (Result<Response.Default, InterfaceError>) -> Void) {
        sendRequest(endpoint: "pause", method: .PUT, data: [], handler: handler)
    }
    
    func stop(handler:@escaping (Result<Response.Default, InterfaceError>) -> Void) {
        sendRequest(endpoint: "stop", method: .PUT, data: [], handler: handler)
    }
    
    private func scheduleRequest<T:Decodable>(endpoint:String, method:Method, data:[String], handler:@escaping (Result<T, InterfaceError>) -> Void, delay:Double = 0.1) {
        let deadline = DispatchTime.now() + delay
        scheduledRequests[endpoint] = deadline
        DispatchQueue.global(qos: .utility).asyncAfter(deadline: deadline) {
            guard self.scheduledRequests[endpoint] == deadline else { return }
            self.sendRequest(endpoint: endpoint, method: method, data: data, handler: handler)
            self.scheduledRequests.removeValue(forKey: endpoint)
        }
    }
    
    private func sendRequest<T:Decodable>(endpoint:String, method:Method, data:[String], handler:@escaping (Result<T, InterfaceError>) -> Void) {
        guard let ip = representation.ip else { return }
        guard let url = URL(string: "http://\(ip):\(representation.port)/\(endpoint)/\(data.joined(separator: ":"))") else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = method.rawValue
            print("request sent to \(url)")
            URLSession.shared.dataTask(with: request) { data, resp, error in
                if let error = error {
                    print("Request error : \(error.localizedDescription)")
                    handler(.failure(.requestFailed))
                    return
                }
                guard let data = data else {
                    handler(.failure(.emptyAnswer))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    handler(.success(result))
                    return
                } catch DecodingError.dataCorrupted(let context) {
                    print(context)
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.valueNotFound(let value, let context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
                handler(.failure(.jsonDecodingFailed))
                return
            }.resume()
        }
    }
    
}
