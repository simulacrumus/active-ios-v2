//
//  ActivityStatusView.swift
//  Active
//
//  Created by Emrah on 2023-04-17.
//

import SwiftUI

struct ActivityStatusView: View {
    
    let activity:Activity
    
    var body: some View {
        HStack{
            Text(activity.availability)
                .font(.caption)
                .foregroundColor(.secondaryWhite)
                .padding(.vertical, 3)
                .padding(.horizontal, 8)
                .background(activity.isAvailable ?? false ? Color.customGreen : Color.customRed)
                .cornerRadius(50)
            Image(systemName: "arrow.triangle.2.circlepath")
                .font(.caption2)
                .foregroundColor(.gray)
            Text(NSLocalizedString("updated", comment: "").appending(" ").appending(activity.lastUpdatedDateTimeString))
                .font(.caption2)
                .foregroundColor(.gray)
            Spacer()
        }
    }
}

struct ActivityStatusView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityStatusView(activity: Activity.sample())
    }
}
