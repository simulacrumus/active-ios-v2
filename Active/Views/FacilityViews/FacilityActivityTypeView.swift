//
//  FacilityActivityTypeView.swift
//  Active
//
//  Created by Emrah on 2022-12-22.
//

import SwiftUI

struct FacilityActivityTypeView: View {

    @StateObject var activityViewModel:ActivityViewModel
    @State var isSheetOpen:Bool = false
    
    let facility:Facility
    let activityType:ActivityType
    
    init(facility: Facility, activityType:ActivityType) {
        self.facility = facility
        self.activityType = activityType
        self._activityViewModel = StateObject(wrappedValue: ActivityViewModel(facilityId: facility.id, activityTypeId: activityType.id))
    }
    var body: some View {
        ScrollView{
            LazyVStack(spacing:0, pinnedViews:[.sectionHeaders]) {
                Section {
                    switch activityViewModel.dataState{
                    case .initial:
                        LoadingView()
                            .padding(.top, 100)
                    case .empty:
                        Text(NSLocalizedString("no_more_available_times", comment: ""))
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding()
                            .padding(.top, 100)
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
                                } label: {
                                    Text(NSLocalizedString("try_again", comment: ""))
                                        .font(.caption)
                                        .bold()
                                }
                            }
                            .padding()
                        }
                    }
                } header: {
                    VStack(spacing:0){
                        HStack{
                            Text(facility.title)
                                .font(.title2)
                                .foregroundColor(.gray)
                                .bold()
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.bottom,10)
                        FacilityActivitySortAndFilterBarView(isAvailable: $activityViewModel.isAvailable, date: $activityViewModel.date)
                            .padding(.bottom,10)
                        Divider()
                    }
                    .background(Color(UIColor.systemBackground))
                }
            }
            .animation(.spring(), value: activityViewModel.activities)
        }
        .searchable(text: $activityViewModel.searchTerm, placement: .navigationBarDrawer(displayMode: .automatic))
        .disableAutocorrection(true)
        .navigationTitle(activityType.title)
        .navigationBarTitleDisplayMode(.automatic)
        .refreshable {
            activityViewModel.fetch()
        }
    }
}

struct FacilityActivityTypeView_Previews: PreviewProvider {
    static var previews: some View {
        FacilityActivityTypeView(facility: Facility.sample(), activityType: ActivityType.sample())
    }
}
