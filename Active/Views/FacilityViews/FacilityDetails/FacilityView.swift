//
//  FacilityView.swift
//  Active
//
//  Created by Emrah on 2022-12-07.
//

import SwiftUI
import MapKit

struct FacilityView: View {
    @StateObject var facilityViewModel:FacilityViewModel
    let facilityId:Int
    
    init(facilityId: Int) {
        self.facilityId = facilityId
        self._facilityViewModel = StateObject(wrappedValue: FacilityViewModel(facilityId: facilityId))
    }
    
    var body: some View {
        ScrollView(showsIndicators: false){
            LazyVStack {
                switch facilityViewModel.dataState{
                case .initial:
                    LoadingView()
                        .padding(.top,100)
                case .empty:
                    Text(NSLocalizedString("no_facility_found", comment: ""))
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding()
                        .padding(.top,100)
                case .error(let message):
                    VStack(spacing: 10){
                        HStack{
                            Image(systemName: "exclamationmark.octagon.fill")
                                .font(.caption)
                                .foregroundColor(.red)
                            Text(message)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        Button {
                            facilityViewModel.fetch(facilityId: facilityId)
                        } label: {
                            Text(NSLocalizedString("try_again", comment: ""))
                                .font(.caption)
                                .bold()
                        }
                    }
                    .padding(.top,100)
                    case .ok:
                        HStack{
                            Text(facilityViewModel.facility!.title)
                                .font(.largeTitle)
                                .bold()
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        .padding(.vertical)
                        FacilityContactView(facility: facilityViewModel.facility!)
                        .padding(.bottom)
                        FacilityLocationView(facility: facilityViewModel.facility!)
                        .padding(.bottom)
                        NavigationLink {
                            FacilityCategoryListView(facility: facilityViewModel.facility!)
                        } label: {
                            HStack{
                                Text("\(NSLocalizedString("browse_activities_at", comment: "")) \(facilityViewModel.facility!.title)")
                                    .font(.subheadline)
                                    .bold()
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(Color.accentColor)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(Color.accentColor)
                            }
                        }
                        .padding(.bottom)
                }
            }
            Spacer()
        }
        .navigationTitle(String())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem (placement: .navigationBarTrailing, content: {
                if facilityViewModel.dataState == .ok{
                    FacilityFavoriteButtonView(facility: facilityViewModel.facility!)
                }
            })
        }
        .refreshable {
            facilityViewModel.fetch(facilityId: facilityId)
        }
        .padding(.horizontal)
    }
}

struct FacilityView_Previews: PreviewProvider {
    static var previews: some View {
        FacilityView(facilityId: Int.zero)
    }
}
