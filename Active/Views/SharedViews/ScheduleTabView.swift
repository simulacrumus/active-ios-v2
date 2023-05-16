//
//  ScheduleTabView.swift
//  OttActivity
//
//  Created by Emrah on 2022-11-25.
//

import SwiftUI

struct ScheduleTabView: View {
    @EnvironmentObject var schedule:Schedule
    @State var isSheetOpen:Bool = false
    
    var body: some View {
        NavigationStack{
            ScrollView() {
                LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                    if schedule.activities.isEmpty {
                        Text(NSLocalizedString("no_scheduled_activities", comment: ""))
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding()
                    }
                    if !schedule.activities.filter({ activity in
                        activity.startDate.isInFuture
                    }).isEmpty{
                        Section {
                            ForEach(schedule.activities.filter({ activity in
                                activity.startDate.isInFuture
                            }).sorted{$0.startDate < $1.startDate}) { activity in
                                Divider()
                                ScheduleActivityListItemView(activity: activity)
                            }
                        } header: {
                            HStack{
                                Text(NSLocalizedString("upcoming", comment: ""))
                                    .font(.title2)
                                    .foregroundColor(.gray)
                                    .bold()
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background(Color(UIColor.systemGray6))
                        }
                    }
                    if !schedule.activities.filter({ activity in
                        activity.startDate.isInPast
                    }).isEmpty{
                        Section {
                            ForEach(schedule.activities.filter({ activity in
                                activity.startDate.isInPast
                            }).sorted{$0.startDate > $1.startDate}) { activity in
                                Divider()
                                ScheduleActivityListItemView(activity: activity)
                            }
                        } header: {
                            HStack{
                                Text(NSLocalizedString("past", comment: ""))
                                    .font(.title2)
                                    .foregroundColor(.gray)
                                    .bold()
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background(Color(UIColor.systemGray6))
                        }
                    }
                }
            }
            .navigationTitle(NSLocalizedString("my_schedule", comment: ""))
            .navigationBarTitleDisplayMode(.large)
            .refreshable {
                schedule.refresh()
            }
        }
    }
}

struct ScheduleTabView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleTabView()
    }
}
