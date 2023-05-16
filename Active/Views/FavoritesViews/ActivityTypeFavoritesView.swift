//
//  ActivityTypeFavoritesView.swift
//  OttActivity
//
//  Created by Emrah on 2022-12-08.
//

import SwiftUI

struct ActivityTypeFavoritesView: View {
    @EnvironmentObject var favorites:Favorites
    var body: some View {
        VStack(spacing: 0){
            if favorites.activityTypes.isEmpty{
                Spacer()
                Text(NSLocalizedString("no_favorite_activity", comment: ""))
                    .foregroundColor(.gray)
                    .font(.caption)
                Spacer()
            } else {
                ScrollView{
                    ForEach(Array(favorites.activityTypes)){ favoriteActivityType in
                        NavigationLink(destination: {
                            ActivityTypeView(activityType: favoriteActivityType)
                        }){
                            FavoriteActivityTypeListItem(activityType: favoriteActivityType)
                            .padding()
                        }
                        Divider()
                    }
                }
            }
        }
        .task {
            favorites.refresh()
        }
    }
}

struct ActivityTypeFavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityTypeFavoritesView()
    }
}
