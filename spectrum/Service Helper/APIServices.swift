//
//  APIServices.swift
//  spectrum
//
//  Created by Shikha Sharma on 1/29/20.
//  Copyright © 2020 Shikha Sharma. All rights reserved.
//

import Foundation
import Alamofire
import SwiftSpinner
final class APIServices {
    
    //shared instance of Class
    static let sharedInstance = APIServices()
    let myGroup = DispatchGroup()
    

    // Get Data API
    func getData(params: [String: AnyObject], completion:@escaping (_ result: NSArray?, _ status: Bool) -> Void) {
        ServiceHelper.sharedInstanceHelper.createRequest(method: .post, showHud: true, params:params as [String : AnyObject], apiName: kGetData) { (result, error) in
            if(error == nil){
                print(result as Any)
                completion((result as! NSArray), true)
            } else {
                completion(nil, false)
            }
        }
    }

}

