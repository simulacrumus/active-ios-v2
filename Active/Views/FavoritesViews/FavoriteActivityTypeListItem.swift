//
//  FavoriteActivityListItem.swift
//  Active
//
//  Created by Emrah on 2023-04-20.
//

import SwiftUI

struct FavoriteActivityTypeListItem: View {
    @StateObject var activityTypeViewModel:ActivityTypeViewModel
    let activityType:ActivityType

    init(activityType: ActivityType) {
        self.activityType = activityType
        self._activityTypeViewModel = StateObject(wrappedValue: ActivityTypeViewModel(activityTypeId: activityType.id))
    }

    var body: some View {
        HStack {
            switch activityTypeViewModel.dataState{
            case .ok:
                Text(activityTypeViewModel.activityType!.title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
            default:
                Text(activityType.title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
            }
            Spacer()
        }
    }
}

struct FavoriteActivityListItem_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteActivityTypeListItem(activityType: ActivityType.sample())
    }
}
