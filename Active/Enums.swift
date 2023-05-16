//
//  Enums.swift
//  Active
//
//  Created by Emrah on 2023-04-13.
//

import Foundation

enum Language{
    case english
    case french
    case other
}

enum FavoriteTag {
    case facility
    case activityType
}

enum WalkthroughTag {
    case welcome
    case disclaimer
    case info
    case ready
}

enum ActivitySortEnum : Hashable, Equatable, CustomStringConvertible{

    case distance
    case time
    case none
    
    var description: String {
        switch self {
            case .distance: return "distance"
            case .time: return "time"
            case .none: return "default"
        }
    }
}

enum FacilitySortEnum : Hashable, Equatable, CustomStringConvertible{
    
    case title
    case distance
    case none
    
    var description: String {
        switch self {
            case .title: return "title"
            case .distance: return "distance"
            case .none: return "default"
        }
    }
}

enum ActivityTypeSortEnum : Hashable, Equatable, CustomStringConvertible{
    
    case title
    case popular
    case none
    
    var description: String {
        switch self {
            case .title: return "title"
            case .popular: return "popular"
            case .none: return ""
        }
    }
}

