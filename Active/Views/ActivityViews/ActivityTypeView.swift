//
//  ActivityTypeView.swift
//  Active
//
//  Created by Emrah on 2022-12-15.
//

import SwiftUI

struct ActivityTypeView: View {
    @EnvironmentObject var favorites:Favorites
    @StateObject var activityViewModel:ActivityViewModel
    @StateObject var facilityViewModel:FacilityViewModel
    @State var isSheetOpen:Bool = false
    private let activityType:ActivityType

    init(activityType: ActivityType){
        self.activityType=activityType
        self._activityViewModel = StateObject(wrappedValue: ActivityViewModel(activityTypeId: activityType.id))
        self._facilityViewModel = StateObject(wrappedValue: FacilityViewModel(activityTypeId: activityType.id))
    }
    
    var body: some View {
        ScrollViewReader{ proxy in
            ScrollView{
                LazyVStack(spacing:0, pinnedViews:[.sectionHeaders]) {
                    Section {
                        switch activityViewModel.dataState{
                        case .initial:
                            LoadingView()
                                .padding(.top,100)
                        case .empty:
                            Text(NSLocalizedString("no_more_available_times", comment: ""))
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
                                    activityViewModel.fetch()
                                    facilityViewModel.fetch()
                                } label: {
                                    Text(NSLocalizedString("try_again", comment: ""))
                                        .font(.caption)
                                        .bold()
                                }
                            }
                            .padding()
                            .padding(.top,100)
                        case .ok:
                            ForEach($activityViewModel.activities){ activity in
                                ActivityListItemView(activity: activity.wrappedValue)
                                Divider()
                            }
                            switch activityViewModel.fetchState {
                            case .idle:
                                Color.clear
                                    .padding()
                                    .onAppear {
                                        activityViewModel.fetchNextPage()
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
                                        activityViewModel.fetch()
                                        facilityViewModel.fetch()
                                    } label: {
                                        Text(NSLocalizedString("try_again", comment: ""))
                                            .foregroundColor(Color.ottawaColor)
                                            .font(.caption)
                                            .bold()
                                    }
                                }
                            }
                        }
                    } header: {
                        VStack(spacing: 0){
                            ActivityTypeSortAndFilterBarView(facilities: $facilityViewModel.facilities, selectedSortEnum: $activityViewModel.sort, selectedFacilityId: $activityViewModel.facilityId, isAvailable: $activityViewModel.isAvailable, activityType: activityType, date: $activityViewModel.date)
                                .padding(.bottom,10)
                            Divider()
                        }
                        .background(Color(UIColor.systemBackground))
                    }
                }.animation(.spring(), value: activityViewModel.activities)
            }
        }
        .searchable(text: $activityViewModel.searchTerm, placement: .navigationBarDrawer(displayMode: .automatic))
        .disableAutocorrection(true)
        .navigationTitle(activityType.title)
        .navigationBarTitleDisplayMode(.large)
        .toolbar{
            ToolbarItem (placement: .navigationBarTrailing, content: {
                ActivityTypeFavoriteButtonView( activityType: activityType)
            })
        }
        .refreshable {
            activityViewModel.fetch()
            facilityViewModel.fetch()
        }
    }
}

struct ActivityTypeView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityTypeView(activityType: ActivityType.sample())
    }
}
