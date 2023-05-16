//
//  FacilityCategoryListView.swift
//  Active
//
//  Created by Emrah on 2022-12-17.
//

import SwiftUI

struct FacilityCategoryListView: View {
    let facility:Facility
    @StateObject var categoryViewModel:CategoryViewModel
    
    init(facility: Facility) {
        self.facility = facility
        self._categoryViewModel = StateObject(wrappedValue: CategoryViewModel(facilityId: facility.id))
    }
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false){
                LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                    Section {
                        switch categoryViewModel.dataState{
                        case .empty:
                            Text(NSLocalizedString("no_more_available_times", comment: ""))
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding()
                                .padding(.top,100)
                        case .initial:
                            LoadingView()
                                .padding(.top,100)
                        case .ok:
                            ForEach(categoryViewModel.categories){ category in
                                Section {
                                    FacilityActivityTypeGridView(category: category, facility: facility)
                                } header: {
                                    HStack{
                                        Text(category.title)
                                            .font(.title3)
                                            .bold()
                                            .multilineTextAlignment(.leading)
                                        Spacer()
                                    }
                                    .background(Color(UIColor.systemBackground))
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal)
                            }
                            switch categoryViewModel.fetchState{
                            case .idle:
                                Color.clear
                                    .padding()
                                    .onAppear {
                                        categoryViewModel.fetchNextPage()
                                    }
                            case .loadedAll:
                                EmptyView()
                                    .padding()
                            case .loading:
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .frame(maxWidth: .infinity)
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
                                        categoryViewModel.fetch()
                                    } label: {
                                        Text(NSLocalizedString("try_again", comment: ""))
                                            .font(.caption)
                                            .bold()
                                    }
                                }
                            }
                        case.error(let message):
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
                                    categoryViewModel.fetch()
                                } label: {
                                    Text(NSLocalizedString("try_again", comment: ""))
                                        .font(.caption)
                                        .bold()
                                }
                            }
                            .padding()
                        }
                    } header: {
                        VStack(spacing: 0, content: {
                            HStack{
                                Text(facility.title)
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.bottom,10)
                            Divider()
                        })
                        .background(Color(UIColor.systemBackground))
                    }
                }
            }
        }
        .navigationBarTitle(NSLocalizedString("activities", comment: ""))
        .navigationBarTitleDisplayMode(.large)
        .refreshable {
            categoryViewModel.fetch()
        }
    }
}

struct FacilityCategoriesListView_Previews: PreviewProvider {
    static var previews: some View {
        FacilityCategoryListView(facility:Facility.sample())
    }
}
