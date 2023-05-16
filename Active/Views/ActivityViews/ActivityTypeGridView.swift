//
//  ActivityTypeGridView.swift
//  Active
//
//  Created by Emrah on 2022-12-14.
//

import SwiftUI

struct ActivityTypeGridView: View {
    @StateObject var activityTypeViewModel:ActivityTypeViewModel
    let category:Category
    
    init(category: Category){
        self.category=category
        self._activityTypeViewModel = StateObject(wrappedValue: ActivityTypeViewModel(categoryId: category.id))
    }
    var body: some View {
        LazyVStack(spacing: 0){
            switch activityTypeViewModel.dataState{
            case .empty:
                Text(NSLocalizedString("no_available_activities", comment: ""))
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding()
                    .padding(.top,100)
            case .initial:
                LoadingView()
                    .padding(.top,100)
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
                                ActivityTypeGridItemView(activityType: activityTypeViewModel.activityTypes[(index * 2)])
                                Spacer()
                                if ((index * 2)+1)<activityTypeViewModel.activityTypes.count{
                                    ActivityTypeGridItemView(activityType: activityTypeViewModel.activityTypes[((index * 2) + 1)])
                                } else {
                                    Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
                                }
                            }
                        }
                    }
                }
                switch activityTypeViewModel.fetchState{
                case .idle:
                    Color.clear
                        .padding()
                        .onAppear {
                            activityTypeViewModel.fetchNextPage()
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
                            activityTypeViewModel.fetch()
                        } label: {
                            Text(NSLocalizedString("try_again", comment: ""))
                                .font(.caption)
                                .bold()
                        }
                    }
                }
            }
        }
    }
}

struct ActivityTypeGridView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityTypeGridView(category: Category.sample())
    }
}
