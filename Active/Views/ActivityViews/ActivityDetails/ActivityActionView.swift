//
//  ActivityActionView.swift
//  Active
//
//  Created by Emrah on 2023-04-17.
//

import SwiftUI

struct ActivityActionView: View {
    @EnvironmentObject var schedule:Schedule
    let activity:Activity
    var body: some View {
        HStack{
            Link(destination: URL(string: activity.reservationURL)!){
                Text(NSLocalizedString("reserve_a_spot", comment: ""))
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(Color.accentColor)
            }
            Spacer()
            Button {
                if schedule.containsActivity(activity){
                    schedule.removeActivity(activity)
                } else {
                    schedule.addActivity(activity)
                }
            } label: {
                Text(schedule.containsActivity(activity) ? NSLocalizedString("remove_from_schedule", comment: "") : NSLocalizedString("add_to_schedule", comment: ""))
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(Color.accentColor)
            }
        }
    }
}

struct ActivityActionView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityActionView(activity: Activity.sample())
    }
}
