//
//  FacilitiesTabView.swift
//  Active
//
//  Created by Emrah on 2022-11-25.
//

import SwiftUI
import UIKit

struct FacilitiesTabView: View {

    @State private var searchText = String()
    @State var isSheetOpen:Bool = false
    @StateObject var facilityViewModel = FacilityViewModel()
    @StateObject var facilityViewModelForSearch = FacilityViewModel()

    var body: some View {
        NavigationStack{
            ScrollView{
                LazyVStack(spacing:0, pinnedViews: [.sectionHeaders]) {
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
                                facilityViewModel.fetch()
                            } label: {
                                Text(NSLocalizedString("try_again", comment: ""))
                                    .font(.caption)
                                    .bold()
                            }
                        }
                        .padding(.top,100)
                    case .ok:
                        Section{
                            ForEach(facilityViewModel.facilities){ facility in
                                NavigationLink(destination: {
                                    FacilityView(facilityId: facility.id)
                                }){
                                    VStack(spacing: 0){
                                        FacilityListItemView(facility: facility)
                                            .padding()
                                        Divider()
                                    }
                                }
                            }
                            switch(facilityViewModel.fetchState){
                            case .idle:
                                Color.clear
                                    .padding()
                                    .onAppear {
                                        facilityViewModel.fetchNextPage()
                                    }
                            case .loading:
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            case .loadedAll:
                                EmptyView()
                                    .padding()
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
                                        facilityViewModel.fetch()
                                    } label: {
                                        Text(NSLocalizedString("try_again", comment: ""))
                                            .font(.caption)
                                            .bold()
                                    }
                                }
                                .padding()
                            }
                        } header: {
                            VStack(spacing: 0) {
                                FacilitySortAndFilterBarView(selectedSortEnum: $facilityViewModel.sort)
                                    .padding(.bottom, 10)
                                Divider()
                            }
                        }
                        .background(Color(UIColor.systemBackground))
                    }
                }
            }
            .animation(.spring(), value: facilityViewModel.facilities)
            .navigationTitle(NSLocalizedString("recreation_facilities", comment: ""))
            .navigationBarTitleDisplayMode(.large)
        }
        .searchable(text: $facilityViewModelForSearch.searchTerm, placement: .navigationBarDrawer(displayMode: .automatic))
        .disableAutocorrection(true)
        .searchSuggestions({
            if !facilityViewModelForSearch.searchTerm.trim().isEmpty{
                FacilitySearchSuggestionsView(facilities: $facilityViewModelForSearch.facilities)
            }
        })
        .refreshable {
            facilityViewModel.fetch()
        }
    }
}

struct FacilitiesTabView_Previews: PreviewProvider {
    static var previews: some View {
        FacilitiesTabView()
    }
}
