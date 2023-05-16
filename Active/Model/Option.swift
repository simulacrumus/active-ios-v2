//
//  Option.swift
//  Active
//
//  Created by Emrah on 2022-12-23.
//

import Foundation

struct ActivitySortOption:Identifiable{
    var id = UUID()
    var sortEnum:ActivitySortEnum
    var title:String
    var subtitle:String
    
    static func options()->[ActivitySortOption]{
        return [
            ActivitySortOption(sortEnum: .distance, title: NSLocalizedString("sort_distance", comment: ""), subtitle: NSLocalizedString("distance", comment: "")),
            ActivitySortOption(sortEnum: .time, title: NSLocalizedString("sort_time", comment: ""), subtitle: NSLocalizedString("time", comment: "")),
        ]
    }
}

struct FacilitySortOption:Identifiable{
    var id = UUID()
    var sortEnum:FacilitySortEnum
    var title:String
    var subtitle:String
    
    static func options()->[FacilitySortOption]{
        return [
            FacilitySortOption(sortEnum: .distance, title: NSLocalizedString("sort_distance", comment: ""), subtitle: NSLocalizedString("distance", comment: "")),
            FacilitySortOption(sortEnum: .title, title: NSLocalizedString("sort_alphabetically", comment: ""), subtitle: NSLocalizedString("alphabetically", comment: ""))
        ]
    }
}

struct ActivityFilterByFaciltyOption:Identifiable{
    var id:Int
    var title:String
    var subtitle:String
    
    static func placeholder()->ActivityFilterByFaciltyOption{
        ActivityFilterByFaciltyOption(id:Int.zero, title: NSLocalizedString("facility", comment: ""), subtitle: NSLocalizedString("select_facility", comment: ""))
    }
}

struct ActivityDayFilterOption:Identifiable{
    var id:Int
    var title:String
    var subtitle:String
    
    static func placeholder()->ActivityDayFilterOption{
        ActivityDayFilterOption(id: -1, title: NSLocalizedString("day", comment: ""), subtitle: NSLocalizedString("select_day", comment: ""))
    }
    
    static func days()->[ActivityDayFilterOption]{
        var days: [ActivityDayFilterOption] = []
        var counter = 0
        while days.count < 7 {
            let currentDate = Date().addDays(numberOfDays: counter)
            days.append(ActivityDayFilterOption(id: counter, title: currentDate.weekDayName, subtitle: currentDate.weekDayName))
            counter += 1
        }
        return days
    }
}

struct ActivityTimeFilterOption:Identifiable{
    var id:Int
    var title:String
    var subtitle:String
    
    static func placeholder()->ActivityTimeFilterOption{
        ActivityTimeFilterOption(id: 0, title: NSLocalizedString("time", comment: ""), subtitle: NSLocalizedString("set_time", comment: ""))
    }
    
    static func options()->[ActivityTimeFilterOption]{
        var counter:Int = 6;
        var result:[ActivityTimeFilterOption] = []
        while counter < 23{
            let currentDate = Calendar.current.date(bySettingHour: counter, minute: 0, second: 0, of: Date())!
            result.append(ActivityTimeFilterOption(id: counter, title: currentDate.time, subtitle: currentDate.time))
            counter += 1
        }
        return result
    }
}
