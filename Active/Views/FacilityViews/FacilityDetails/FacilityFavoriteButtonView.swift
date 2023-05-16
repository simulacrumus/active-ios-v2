//
//  FacilityFavoriteButtonView.swift
//  Active
//
//  Created by Emrah on 2023-04-18.
//

import SwiftUI

struct FacilityFavoriteButtonView: View {
    @EnvironmentObject var favorites:Favorites
    @State var isSheetOpen:Bool = false
    let facility:Facility
    
    var body: some View {
        Button{
            if favorites.containsFacility(facility){
                favorites.removeFacility(facility)
            } else {
                favorites.addFacility(facility)
            }
            isSheetOpen = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                isSheetOpen = false
            }
        }label: {
            HStack{
                Image(systemName: favorites.containsFacility(facility) ? "star.fill" : "star")
                    .font(.caption)
                    .foregroundColor(Color.accentColor)
            }
            .padding(.vertical)
            .padding(.leading)
        }
        .sheet(isPresented: $isSheetOpen){
            FavoritesSnackBarView(message: favorites.containsFacility(facility) ? NSLocalizedString("added_to_favorite_facilities", comment: "") : NSLocalizedString("removed_from_favorite_facilities", comment: ""))
        }
    }
}

struct FacilityFavoriteButtonView_Previews: PreviewProvider {
    static var previews: some View {
        FacilityFavoriteButtonView(facility: Facility.sample())
    }
}
