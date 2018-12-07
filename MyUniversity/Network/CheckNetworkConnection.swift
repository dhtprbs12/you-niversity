//
//  CheckNetworkConnection.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 5. 22..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import SystemConfiguration

public class CheckNetworkConnection {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr()
        zeroAddress.sa_len = UInt8(MemoryLayout<sockaddr>.size)
        zeroAddress.sa_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }) else { return false }
        
        var flags = SCNetworkReachabilityFlags()
        guard SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) else { return false }
        
        return flags.contains(.reachable) && !flags.contains(.connectionRequired)
    }
    
}
