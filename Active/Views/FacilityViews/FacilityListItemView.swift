//
//  FacilityListItemView.swift
//  Active
//
//  Created by Emrah on 2022-12-07.
//

import SwiftUI

struct FacilityListItemView: View {
    let facility:Facility
    var body: some View {
        VStack(spacing: 10){
            HStack{
                Text(facility.title)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.secondaryText)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            HStack{
                Text(facility.address.street)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                Spacer()
                Text(facility.distanceString)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
            }
        }
    }
}

struct FacilityListItemView_Previews: PreviewProvider {
    static var previews: some View {
        FacilityListItemView(facility: Facility.sample())
    }
}
