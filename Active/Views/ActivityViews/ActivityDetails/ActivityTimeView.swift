//
//  ActivityTimeView.swift
//  Active
//
//  Created by Emrah on 2023-04-17.
//

import SwiftUI

struct ActivityTimeView: View {
    let activity:Activity
    var body: some View {
        HStack{
            Image(systemName: "clock")
                .font(.body)
                .foregroundColor(.secondaryText)
            Text("\(activity.startDateString) • \(activity.startAndEndTimeString)" )
                .font(.body)
                .foregroundColor(.secondaryText)
            Spacer()
        }
    }
}

struct ActivityTimeView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityTimeView(activity: Activity.sample())
    }
}
