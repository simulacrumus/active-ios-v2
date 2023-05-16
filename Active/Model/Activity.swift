//
//  Activity.swift
//  Active
//
//  Created by Emrah on 2022-11-25.
//

import Foundation

struct ActivityPage: Codable{
    var content:[Activity]
    var last:Bool
    var totalElements:Int
    var totalPages:Int
}

struct Activity: Codable, Identifiable, Hashable{
    var id: Int
    var title: String
    var facility: Facility
    var category: String
    var type: String
    var reservationURL: String
    var startTime:String
    var endTime:String
    var minAge:Int?
    var maxAge:Int?
    var isAvailable: Bool?
    var lastUpdated: String
    
    var startDate:Date{
        Date.getDate(from: self.startTime)
    }
    
    var endDate:Date{
        Date.getDate(from: self.endTime)
    }
    
    var startDateString:String{
        Date.getDate(from: self.startTime).date
    }
    
    var startTimeString:String{
        Date.getDate(from: self.startTime).time
    }
    
    var endTimeString:String{
        Date.getDate(from: self.endTime).time
    }
    
    var startDayName:String{
        Date.getDate(from: self.startTime).weekDayName
    }
    
    var startAndEndTimeString:String{
        "\(self.startTimeString) - \(self.endTimeString)"
    }
    
    var startAndEndDateTimeString:String{
        "\(self.startDateString) \(self.startTimeString) - \(self.endTimeString)"
    }
    
    var startAndEndTimeWithDay:String{
        "\(self.startDate > Date().midnight ? self.startDayName : self.startDateString), \(self.startTimeString) - \(self.endTimeString)"
    }
    
    var lastUpdatedDateTimeString:String{
        Date.getDate(from: self.lastUpdated).relativeDateTime
    }
    
    var availability:String{
        self.isAvailable ?? false ? NSLocalizedString("available", comment: "") : NSLocalizedString("full", comment: "")
    }
    
    static func sample() -> Activity {
        let facility = Facility.sample()
        return Activity(
            id: Int.zero,
            title: "Aquafit General - Deep",
            facility: facility,
            category: "Swimming",
            type: "Aquafitness",
            reservationURL: "Test reservation link",
            startTime:"Date()",
            endTime:"Date()",
            minAge:Int.zero,
            maxAge:Int.zero,
            isAvailable: true,
            lastUpdated: "Date()"
        )
    }
}
