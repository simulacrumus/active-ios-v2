//
//  Category.swift
//  Active
//
//  Created by Emrah on 2022-12-13.
//

import Foundation

struct Category: Codable, Identifiable, Hashable{
    var id:Int
    var title:String
    
    static func getCategoryImage(for categoryId:Int)-> String{
        switch categoryId{
        case 11:
            return "figure.pool.swim"
        case 12:
            return "figure.cooldown"
        case 13:
            return "figure.tennis"
        case 14:
            return "figure.hockey"
        default:
            return ""
        }
    }
    
    static func sample()-> Category{
        return Category(
            id: 11,
            title: "Swimming"
        )
    }
    
}

struct CategoryPage: Codable{
    var content:[Category]
    var last:Bool
    var totalElements:Int
    var totalPages:Int
}
