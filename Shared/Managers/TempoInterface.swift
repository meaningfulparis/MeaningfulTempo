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
            let activity:TempoRepresentation.Activity
            let timerDuration:Int
            let timerRelativeStart:TimeInterval?
            let battery:Int
        }
    }
    
    enum Method:String {
        case GET, PUT, POST
    }
    
    enum InterfaceError:Error {
        case requestFailed, emptyAnswer, jsonDecodingFailed, unknownIP, URLInitializationFailed
    }
    
    private let digitalRepresentation:TempoDigitalRepresentation
    private var scheduledRequests:[String:DispatchTime] = [:]
    
    init(digitalRepresentation:TempoDigitalRepresentation) {
        self.digitalRepresentation = digitalRepresentation
    }
    
    func detectTempoConfiguration(handler: @escaping (Result<Response.Default, InterfaceError>) -> Void) {
        guard let url = getRequestURL(ip: TempoConfiguration.configurationIP, endpoint: "object-state") else {
            handler(.failure(.URLInitializationFailed))
            return
        }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 4.5)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        print("-> Tempo looking for wifi sent to \(url)")
        send(request: request, handler: handler)
    }
    
    func getObjectState(handler:@escaping (Result<Response.Default, InterfaceError>) -> Void) {
        sendConnectObjectRequest(endpoint: "object-state", method: .GET, data: [], handler: handler)
    }
    
    func setTimer(duration:Int, handler:@escaping (Result<Response.Default, InterfaceError>) -> Void) {
        scheduleRequest(endpoint: "set-timer", method: .PUT, data: [String(duration)], handler: handler)
    }
    
    func launch(duration:Int, handler:@escaping (Result<Response.Default, InterfaceError>) -> Void) {
        sendConnectObjectRequest(endpoint: "launch", method: .PUT, data: [String(duration)], handler: handler)
    }
    
    func pause(handler:@escaping (Result<Response.Default, InterfaceError>) -> Void) {
        sendConnectObjectRequest(endpoint: "pause", method: .PUT, data: [], handler: handler)
    }
    
    func stop(handler:@escaping (Result<Response.Default, InterfaceError>) -> Void) {
        sendConnectObjectRequest(endpoint: "stop", method: .PUT, data: [], handler: handler)
    }
    
    private func scheduleRequest<T:Decodable>(endpoint:String, method:Method, data:[String], handler:@escaping (Result<T, InterfaceError>) -> Void, delay:Double = 0.1) {
        let deadline = DispatchTime.now() + delay
        scheduledRequests[endpoint] = deadline
        DispatchQueue.global(qos: .utility).asyncAfter(deadline: deadline) {
            guard self.scheduledRequests[endpoint] == deadline else { return }
            self.sendConnectObjectRequest(endpoint: endpoint, method: method, data: data, handler: handler)
            self.scheduledRequests.removeValue(forKey: endpoint)
        }
    }
    
    /*
     
     Configuration
     
     */
    
    func transferWiFiNetwork(ssid:String, password:String, handler:@escaping (Result<Response.Default, InterfaceError>) -> Void) {
        if digitalRepresentation.activity == .LookingForWifi {
            sendConfigurationObjectRequest(endpoint: "learn-wifi-network", method: .POST, data: [ssid,password], handler: handler)
        } else {
            sendConnectObjectRequest(endpoint: "learn-wifi-network", method: .POST, data: [ssid, password], handler: handler)
        }
    }
    
    func getKnownWiFiNetworks(handler:@escaping (Result<[TempoConfigurator.WiFiNetwork], InterfaceError>) -> Void) {
        if digitalRepresentation.activity == .LookingForWifi {
            sendConfigurationObjectRequest(endpoint: "known-wifi-network", method: .GET, data: [], handler: handler)
        } else {
            sendConnectObjectRequest(endpoint: "known-wifi-network", method: .GET, data: [], handler: handler)
        }
    }
    
    func trashWiFiNetwork(ssid:String, handler:@escaping (Result<Response.Default, InterfaceError>) -> Void) {
        if digitalRepresentation.activity == .LookingForWifi {
            sendConfigurationObjectRequest(endpoint: "trash-wifi", method: .POST, data: [ssid], handler: handler)
        } else {
            sendConnectObjectRequest(endpoint: "trash-wifi", method: .POST, data: [ssid], handler: handler)
        }
    }
    
    /*
     
     Helpers
     
     */
    
    fileprivate func getRequestURL(ip:String, endpoint:String, data:[String] = []) -> URL? {
        let parameters = "\(data.joined(separator: ":"))".addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        return URL(string: "http://\(ip):\(TempoConfiguration.port)/\(endpoint)/\(parameters)")
    }
    
    private func sendConnectObjectRequest<T:Decodable>(endpoint:String, method:Method, data:[String], handler:@escaping (Result<T, InterfaceError>) -> Void) {
        guard let ip = digitalRepresentation.ip else {
            handler(.failure(.unknownIP))
            return
        }
        sendRequest(ip: ip, endpoint: endpoint, method: method, data: data, handler: handler)
    }
    
    private func sendConfigurationObjectRequest<T:Decodable>(endpoint:String, method:Method, data:[String], handler:@escaping (Result<T, InterfaceError>) -> Void) {
        sendRequest(ip: TempoConfiguration.configurationIP, endpoint: endpoint, method: method, data: data, handler: handler)
    }
    
    private func sendRequest<T:Decodable>(ip: String, endpoint:String, method:Method, data:[String], handler:@escaping (Result<T, InterfaceError>) -> Void) {
        guard let url = getRequestURL(ip: ip, endpoint: endpoint, data: data) else {
            handler(.failure(.URLInitializationFailed))
            return
        }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = method.rawValue
        print("[Request sent to \(url)]")
        send(request: request, handler: handler)
    }
    
    private func send<T:Decodable>(request:URLRequest, handler:@escaping (Result<T, InterfaceError>) -> Void) {
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
