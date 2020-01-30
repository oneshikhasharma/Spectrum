//
//  Members.swift
//  spectrum
//
//  Created by Shikha Sharma on 1/30/20.
//  Copyright © 2020 Shikha Sharma. All rights reserved.
//

import Foundation
import ObjectMapper


struct Members : Mappable {
    var age : Int?
    var _id : String?
    var email : String?
    var phone : String?
    var name : Name?
    var favorite : String? = "1"
    
    init?(map: Map){}
    
    mutating func mapping(map: Map) {
        age <- map["age"]
        _id <- map["_id"]
        email <- map["email"]
        phone <- map["phone"]
        name <- map["name"]
        favorite <- map["favorite"]
        
    }
}

struct Name : Mappable{
    var first : String?
    var last : String?
    
    init?(map: Map){}
    
    mutating func mapping(map: Map) {
        first <- map["first"]
        last <- map["last"]
    }
}
