//
//  ScheduleActivityListItemView.swift
//  Active
//
//  Created by Emrah on 2023-04-20.
//

import SwiftUI

struct ScheduleActivityListItemView: View {
    
    @StateObject var activityViewModel:ActivityViewModel
    let activity:Activity
    
    init(activity: Activity) {
        self.activity = activity
        self._activityViewModel = StateObject(wrappedValue: ActivityViewModel(activityId: activity.id))
    }
    
    var body: some View {
        LazyVStack(spacing: 0) {
            switch activityViewModel.dataState{
            case .ok:
                ActivityListItemView(activity: activityViewModel.activity!) // Refresh for current language
            default:
                ActivityListItemView(activity: activity) // With language when saved
            }
        }
    }
}

struct ScheduleActivityListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleActivityListItemView(activity: Activity.sample())
    }
}
