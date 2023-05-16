//
//  FacilityActivityTypeGridItemView.swift
//  Active
//
//  Created by Emrah on 2022-12-18.
//

import SwiftUI

struct FacilityActivityTypeGridItemView: View {
    let facility:Facility
    let activityType:ActivityType
    var body: some View {
        NavigationLink(destination: {
            FacilityActivityTypeView(facility: facility, activityType: activityType)
            }){
                VStack{
                    HStack{
                        Text(activityType.title)
                            .font(.body)
                            .bold()
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer()
                }
                .padding()
                .frame(height: 100)
                .background(Color.ottawaColorAdjusted)
                .cornerRadius(5)
            }
    }
}

struct FacilityActivityTypeItemView_Previews: PreviewProvider {
    static var previews: some View {
        FacilityActivityTypeGridItemView(facility: Facility.sample(), activityType: ActivityType.sample())
    }
}
