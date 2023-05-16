//
//  ActivityType.swift
//  Active
//
//  Created by Emrah on 2022-12-08.
//

import Foundation

struct ActivityType: Codable, Identifiable, Hashable{
    var id:Int
    var title:String
    var category:String
    
    static func sample()-> ActivityType{
        return ActivityType(
            id: 1,
            title: "Lane Swim",
            category: "Swimming"
        )
    }
}

struct ActivityTypePage: Codable{
    var content:[ActivityType]
    var last:Bool
    var totalElements:Int
    var totalPages:Int
}
