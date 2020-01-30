//
//  ServiceHelper.swift
//  spectrum
//
//  Created by Shikha Sharma on 1/29/20.
//  Copyright © 2020 Shikha Sharma. All rights reserved.
//


import Foundation
import Alamofire
import SwiftSpinner
import SystemConfiguration
final class ServiceHelper {
    
    //shared instance of Class
    class var sharedInstanceHelper: ServiceHelper {
        struct Static {
            static let instance = ServiceHelper()
        }
        return Static.instance
    }
    
    
    /// Create Request for webservice
    ///
    /// - Parameters:
    ///   - method: request type (post, get, put)
    ///   - params: request parameters
    ///   - apiName: api name to create url
    ///   - completionHandler: closure
    
    
    
    func createRequest(method: HTTPMethod,showHud :Bool, params: [String: AnyObject]!, apiName: String, completionHandler:@escaping (_ response: AnyObject?, _ error: NSError?) -> Void) {
        if showHud {
           // SwiftSpinner.show("Loading")
        }
        
        let url = kBaseURL + apiName
        Alamofire.request(url, method: method, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if showHud {
                SwiftSpinner.hide()
            }
            switch response.result {
            case .success(_):
                // self.hideHud()
                completionHandler(response.result.value as AnyObject?, nil)
            case .failure(_):
                //self.hideHud()
                print(response.result.value as AnyObject? as Any)
                completionHandler(nil, response.result.error as NSError?)
            }
        }
        
    }
    
    func createRawRequest(apiName: String, params: Dictionary<String, Any>, completionHandler:@escaping (_ response: AnyObject?, _ error: NSError?) -> Void) {
        let urlString = kBaseURL + apiName
        guard let url = URL(string: urlString) else {return}
        var request        = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody   = try JSONSerialization.data(withJSONObject: params)
        } catch let error {
            print("Error : \(error.localizedDescription)")
        }
        Alamofire.request(request).responseJSON{ response in
            switch response.result {
            case .success(_):
                // self.hideHud()
                completionHandler(response.result.value as AnyObject?, nil)
            case .failure(_):
                //self.hideHud()
                print(response.result.value as AnyObject? as Any)
                completionHandler(nil, response.result.error as NSError?)
            }
        }
    }

}
    
public func isConnectedToNetwork() -> Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            SCNetworkReachabilityCreateWithAddress(nil, $0)
        }
    }) else {
        return false
    }
    
    var flags: SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
        return false
    }
    if flags.isEmpty {
        return false
    }
    
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    
    return (isReachable && !needsConnection)
}


