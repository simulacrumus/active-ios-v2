//
//  MySchedule.swift
//  Active
//
//  Created by Emrah on 2023-01-13.
//

import Foundation

class Schedule: ObservableObject {
    @Published var activities: Set<Activity> = []

    let defaults = UserDefaults.standard

    init() {
        let decoder = PropertyListDecoder()
        
        if let data = defaults.value(forKey: "My_Schedule_Activities") as? Data {
            let activityData = try? decoder.decode(Set<Activity>.self, from: data)
            self.activities = activityData ?? []
        } else {
            self.activities = []
        }
    }
    
    func refresh(){
        let decoder = PropertyListDecoder()
        
        if let data = defaults.value(forKey: "My_Schedule_Activities") as? Data {
            let activityData = try? decoder.decode(Set<Activity>.self, from: data)
            self.activities = activityData ?? []
        } else {
            self.activities = []
        }
    }

    func containsActivity(_ myScheduleActivity:Activity)-> Bool{
        return activities.contains(myScheduleActivity)
    }
    
    func addActivity(_ myScheduleActivity:Activity) {
        activities.insert(myScheduleActivity)
        saveActivity()
    }

    func removeActivity(_ myScheduleActivity:Activity) {
        activities.remove(myScheduleActivity)
        saveActivity()
    }
    
    func saveActivity() {
        let encoder = PropertyListEncoder()
        if let encoded = try? encoder.encode(self.activities) {
            self.defaults.set(encoded, forKey: "My_Schedule_Activities")
        }
        defaults.synchronize()
    }
}
