//
//  FacilityFavoritesView.swift
//  OttActivity
//
//  Created by Emrah on 2022-12-08.
//

import SwiftUI

struct FacilityFavoritesView: View {
    @EnvironmentObject var favorites:Favorites
    var body: some View {
        VStack(spacing: 0){
            if favorites.facilities.isEmpty{
                Spacer()
                Text(NSLocalizedString("no_favorite_facility", comment: ""))
                    .foregroundColor(.gray)
                    .font(.caption)
                Spacer()
            } else {
                ScrollView{
                    ForEach(Array(favorites.facilities)){ facility in
                        NavigationLink(destination: {
                            FacilityView(facilityId: facility.id)
                        }){
                            FavoriteFacilityListItem(facility: facility)
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

struct FacilityFavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FacilityFavoritesView()
    }
}
