//
//  TempoFinder.swift
//  Tempo
//
//  Created by Romain Penchenat on 10/09/2021.
//

import Foundation

protocol TempoFinderDelegate {
    func didFindWaitingConfigurationTempo(ip:String, result: Result<TempoInterface.Response.Default, TempoInterface.InterfaceError>)
    func didFindTempo(ip:String)
}

class TempoFinder {
    
    var delegate:TempoFinderDelegate?
    private var interface:TempoInterface
    private let tempoHostName = TempoConfiguration.hostname
    private var lookForTempoOnWifiWorkItem:DispatchWorkItem?
    private var lookForWaitingConfigurationTempoWorkItem:DispatchWorkItem?
    
    init(withInterface interface:TempoInterface) {
        self.interface = interface
    }
    
    func lookForTempo() {
        lookForTempoOnWifiWorkItem?.cancel()
        lookForWaitingConfigurationTempoWorkItem?.cancel()
        lookForTempoOnWifiWorkItem =  DispatchWorkItem(block: lookForAvailableTempoOnWifi)
        lookForWaitingConfigurationTempoWorkItem =  DispatchWorkItem(block: lookForWaitingConfigurationTempo)
        DispatchQueue.global(qos: .utility).async(execute: lookForTempoOnWifiWorkItem!)
        DispatchQueue.global(qos: .utility).async(execute: lookForWaitingConfigurationTempoWorkItem!)
    }
    
    private func didFindTempo() {
        lookForTempoOnWifiWorkItem?.cancel()
        lookForWaitingConfigurationTempoWorkItem?.cancel()
    }
    
    private func lookForAvailableTempoOnWifi() {
//        print("||| Look for tempo |||")
        for i in 0..<255 {
            let ip = "192.168.1.\(i)"
//            if let hostName = self.getHostName(ip), hostName != ip {
//                print("----> ", hostName)
//            }
            if let hostName = self.getHostName(ip), hostName.contains(self.tempoHostName) {
                self.didFindTempo()
                self.delegate?.didFindTempo(ip: ip)
                return
            }
//            delegate?.didFindTempo(ip: "192.168.1.34")
//            return
        }
    }
    
    private func lookForWaitingConfigurationTempo() {
        interface.detectTempoConfiguration { result in
            switch result {
            case .failure(let error):
                print("Tempo looking for wifi not found : \(error.localizedDescription)")
            case .success(_):
                self.didFindTempo()
                self.delegate?.didFindWaitingConfigurationTempo(ip: TempoConfiguration.configurationIP, result: result)
            }
        }
    }
    
    private func getHostName(_ ipaddress: String) -> String? {
        
        var hostName:String? = nil
        var ifinfo: UnsafeMutablePointer<addrinfo>?
        
        /// Get info of the passed IP address
        if getaddrinfo(ipaddress, nil, nil, &ifinfo) == 0 {
            
            var ptr = ifinfo
            while ptr != nil {
                
                let interface = ptr!.pointee
                
                /// Parse the hostname for addresses
                var hst = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                if getnameinfo(interface.ai_addr, socklen_t(interface.ai_addrlen), &hst, socklen_t(hst.count),
                               nil, socklen_t(0), 0) == 0 {
                    
                    if let address = String(validatingUTF8: hst) {
                        hostName = address
                    }
                }
                ptr = interface.ai_next
            }
            freeaddrinfo(ifinfo)
        }
        
        return hostName
    }
    
}
