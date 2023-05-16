//
//  FacilityActivityTypeGridView.swift
//  Active
//
//  Created by Emrah on 2022-12-18.
//

import SwiftUI

struct FacilityActivityTypeGridView: View {
    let category:Category
    let facility:Facility
    @StateObject var activityTypeViewModel:ActivityTypeViewModel
    
    init(category: Category, facility:Facility){
        self.category=category
        self.facility=facility
        self._activityTypeViewModel = StateObject(wrappedValue: ActivityTypeViewModel(categoryId: category.id,facilityId: facility.id))
    }
    
    var body: some View {
        LazyVStack(spacing:0, pinnedViews:[.sectionHeaders]) {
            switch activityTypeViewModel.dataState{
            case .initial:
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .padding(.top,100)
            case .empty:
                Text(NSLocalizedString("no_available_activities", comment: ""))
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
                        activityTypeViewModel.fetch()
                    } label: {
                        Text(NSLocalizedString("try_again", comment: ""))
                            .font(.caption)
                            .bold()
                    }
                }
                .padding()
                .padding(.top,100)
            case .ok:
                Grid(alignment: .topLeading){
                    ForEach(0..<((activityTypeViewModel.activityTypes.count+1)/2), id: \.self) { index in
                        GridRow{
                            HStack{
                                FacilityActivityTypeGridItemView(facility: facility, activityType: activityTypeViewModel.activityTypes[(index * 2)])
                                Spacer()
                                if ((index * 2)+1)<activityTypeViewModel.activityTypes.count{
                                    FacilityActivityTypeGridItemView(facility: facility, activityType: activityTypeViewModel.activityTypes[((index * 2) + 1)])
                                } else {
                                    Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
                                }
                            }
                        }
                    }
                }
                switch activityTypeViewModel.fetchState {
                case .idle:
                    Color.clear
                        .padding()
                        .onAppear {
                            activityTypeViewModel.fetchNextPage()
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
                            activityTypeViewModel.fetch()
                        } label: {
                            Text(NSLocalizedString("try_again", comment: ""))
                                .font(.caption)
                                .bold()
                        }
                    }
                    .padding()
                    .padding(.top,100)
                }
            }
        }
    }
}

struct FacilityActivityTypeGridView_Previews: PreviewProvider {
    static var previews: some View {
        FacilityActivityTypeGridView(category: Category.sample(), facility: Facility.sample())
    }
}
