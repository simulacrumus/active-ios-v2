//
//  TabBarView.swift
//  OttActivity
//
//  Created by Emrah on 2022-11-25.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView() {
            ActivitiesTabView()
                .tabItem {
                    Image(systemName: "figure.run")
                    Text(NSLocalizedString("activities", comment: ""))
                }
            FacilitiesTabView()
                .tabItem {
                    Image(systemName: "building.2")
                    Text(NSLocalizedString("facilities", comment: ""))
                }
            FavoritesTabView()
                .tabItem {
                    Image(systemName: "star")
                    Text(NSLocalizedString("favorites", comment: ""))
                    
                }
            ScheduleTabView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text(NSLocalizedString("my_schedule", comment: ""))
                }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
