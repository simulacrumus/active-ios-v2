//
//  Facility.swift
//  Active
//
//  Created by Emrah on 2022-12-07.
//

import Foundation

struct Facility: Codable, Identifiable, Hashable{
    var id:Int
    var title:String
    var address:Address
    var phone:String
    var email:String
    var url:String
    var latitude:Double
    var longitude:Double
    var distance:Double
    
    var distanceString:String{
        return self.distance < 1000.0 ?
        String(format: "%.0f m", self.distance) :
        String(format: "%.1f km", self.distance / 1000)
    }
    
    static func sample()->Facility{
        return Facility(
            id: 10033,
            title: "Pinecrest Recreation Centre",
            address: Address.sample(),
            phone: "613-580-9600",
            email: "sports@ottawa.ca",
            url: "https://ottawa.ca/en/recreation-and-parks/recreation-facilities/facility-listing/bob-macquarrie-recreation-complex-orleans",
            latitude: 45.4661876,
            longitude: -75.5449273,
            distance: 13.2
        )
    }
}

struct FacilityPage: Codable{
    var content:[Facility]
    var last:Bool
    var totalElements:Int
    var totalPages:Int
}
