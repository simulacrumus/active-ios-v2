//
//  Address.swift
//  Active
//
//  Created by Emrah on 2023-04-10.
//

import Foundation

struct Address: Codable, Identifiable, Hashable{
    var id:Int
    var street:String
    var city:String
    var province:String
    var postalCode:String
    var country:String
    
    var mediumAddress:String{
        "\(self.street) \(self.city) \(self.province) \(self.postalCode)"
    }
    
    var fullAddress:String{
        "\(self.street) \(self.city) \(self.province) \(self.postalCode) \(self.country)"
    }
    
    static func sample()->Address{
        return Address(
            id:1,
            street: "1490 Youville Drive",
            city: "Ottawa",
            province: "ON",
            postalCode: "K1C2X8",
            country: "Canada"
        )
    }
}
