//
//  ActivityTypeFavoriteButtonView.swift
//  Active
//
//  Created by Emrah on 2023-04-18.
//

import SwiftUI

struct ActivityTypeFavoriteButtonView: View {
    @EnvironmentObject var favorites:Favorites
    @State var isSheetOpen:Bool = false
    let activityType:ActivityType
    
    var body: some View {
        Button{
            if favorites.containsActivityType(activityType){
                favorites.removeActivityType(activityType)
            } else {
                favorites.addActivityType(activityType)
            }
            isSheetOpen = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                isSheetOpen = false
            }
        }label: {
            HStack{
                Image(systemName: favorites.containsActivityType(activityType) ? "star.fill" : "star")
                    .font(.caption)
                    .foregroundColor(Color.accentColor)
            }
            .padding(.vertical)
            .padding(.leading)
        }
        .sheet(isPresented: $isSheetOpen){
            FavoritesSnackBarView(message: favorites.containsActivityType(activityType) ? NSLocalizedString("added_to_favorite_activities", comment: "") : NSLocalizedString("removed_from_favorite_activities", comment: ""))
        }
    }
}

struct ActivityTypeFavoriteButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityTypeFavoriteButtonView(activityType: ActivityType.sample())
    }
}
