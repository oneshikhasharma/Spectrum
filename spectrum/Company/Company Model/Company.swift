//
//  Category.swift
//  Local Hero Consumer
//
//  Created by Sudhanshu S on 08/04/19.
//  Copyright © 2019 Actiknow. All rights reserved.
//

import Foundation
import ObjectMapper


struct Company : Mappable {
  
    var _id : String?
    var company : String?
    var website : String?
    var logo : String?
    var about : String?
    var follow : String? = "1"
    var favorite : String? = "1"
    
    var members : [Members]?
    
    init?(map: Map){}
    
    mutating func mapping(map: Map) {
        _id <- map["_id"]
        company <- map["company"]
        website <- map["website"]
        logo <- map["logo"]
        about <- map["about"]
        follow <- map["follow"]
        favorite <- map["favorite"]
        
        members <- map["members"]
    }
}

