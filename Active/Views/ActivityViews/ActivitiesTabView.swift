//
//  ActivitiesTabView.swift
//  Active
//
//  Created by Emrah on 2022-12-04.
//

import SwiftUI

struct ActivitiesTabView: View {
    @StateObject var categoryViewModel = CategoryViewModel()
    @StateObject var activityTypeViewModel = ActivityTypeViewModel()
    @StateObject var popularActivityTypeViewModel = ActivityTypeViewModel(sort: .popular)

    var body: some View {
        NavigationStack {
            VStack(spacing: 0){
                switch categoryViewModel.dataState{
                case .empty:
                    Text(NSLocalizedString("no_available_categories", comment: ""))
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding()
                case .initial:
                    LoadingView()
                        .padding()
                case .ok:
                    ScrollView(showsIndicators: false){
                        LazyVStack(spacing: 20){
                            Section {
                                CategoryGridView(categories: categoryViewModel.categories)
                            } header: {
                                HStack{
                                    Text(NSLocalizedString("browse_categories", comment: ""))
                                        .font(.title2)
                                        .bold()
                                    Spacer()
                                }
                            }
                            Section {
                                PopularActivityGridView(activityTypes: popularActivityTypeViewModel.activityTypes)
                            } header: {
                                HStack{
                                    Text(NSLocalizedString("popular_activities", comment: ""))
                                        .font(.title2)
                                        .bold()
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding()
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
                                popularActivityTypeViewModel.fetch()
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
                            popularActivityTypeViewModel.fetch()
                        } label: {
                            Text(NSLocalizedString("try_again", comment: ""))
                                .font(.caption)
                                .bold()
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(NSLocalizedString("drop_in_activities", comment: ""))
            .navigationBarTitleDisplayMode(.automatic)
            .padding(.top, -16)
        }
        .refreshable {
            activityTypeViewModel.fetch()
            popularActivityTypeViewModel.fetch()
            categoryViewModel.fetch()
        }
        .searchable(text: $activityTypeViewModel.searchTerm, placement: .navigationBarDrawer(displayMode: .automatic))
        .disableAutocorrection(true)
        .searchSuggestions({
            if !activityTypeViewModel.searchTerm.trim().isEmpty{
                ActivityTypeSearchSuggestionsView(activityTypes: $activityTypeViewModel.activityTypes)
            }
        })
    }
}

struct ActivitiesTabView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesTabView()
    }
}
