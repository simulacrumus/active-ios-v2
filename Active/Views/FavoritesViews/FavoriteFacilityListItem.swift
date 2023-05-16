//
//  FavoriteFacilityListItem.swift
//  Active
//
//  Created by Emrah on 2023-04-19.
//

import SwiftUI

struct FavoriteFacilityListItem: View {
    @StateObject var facilityViewModel:FacilityViewModel
    let facility:Facility
    
    init(facility: Facility) {
        self.facility = facility
        self._facilityViewModel = StateObject(wrappedValue: FacilityViewModel(facilityId: facility.id))
    }
    
    var body: some View {
        HStack {
            switch facilityViewModel.dataState{
            case .ok:
                Text(facilityViewModel.facility!.title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
            default:
                Text(facility.title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
            }
            Spacer()
        }
    }
}

struct FavoriteFacilityListItem_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteFacilityListItem(facility: Facility.sample())
    }
}
