//
//  ActivityFacilityView.swift
//  Active
//
//  Created by Emrah on 2023-04-17.
//

import SwiftUI

struct ActivityFacilityView: View {
    
    let activity:Activity
    
    var body: some View {
        HStack{
            Image(systemName: "building.2")
                .font(.body)
                .foregroundColor(.secondaryText)
            Text(activity.facility.title)
                .font(.body)
                .foregroundColor(.secondaryText)
                .multilineTextAlignment(.leading)
            Spacer()
        }
    }
}

struct ActivityFacilityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityFacilityView(activity: Activity.sample())
    }
}
