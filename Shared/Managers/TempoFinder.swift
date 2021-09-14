//
//  TempoFinder.swift
//  Tempo
//
//  Created by Romain Penchenat on 10/09/2021.
//

import Foundation

protocol TempoFinderDelegate {
    func didFindTempo(ip:String)
    func tempoNotFound()
}

class TempoFinder {
    
    var delegate:TempoFinderDelegate?
    private let tempoHostName = "arduino-a570"
    
    init() {
        lookForTempo()
    }
    
    func lookForTempo() {
        DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + 2) {
            print("||| Look for tempo |||")
            for i in 0..<255 {
                let ip = "192.168.1.\(i)"
                if let hostName = self.getHostName(ip), hostName != ip {
                    print("----> ", hostName)
                }
                if let hostName = self.getHostName(ip), hostName.contains(self.tempoHostName) {
                    self.delegate?.didFindTempo(ip: ip)
                    return
                }
    //            delegate?.didFindTempo(ip: "192.168.1.34")
    //            return
            }
            self.delegate?.tempoNotFound()
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
