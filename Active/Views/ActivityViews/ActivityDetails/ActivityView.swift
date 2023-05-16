//
//  ActivityView.swift
//  Active
//
//  Created by Emrah on 2022-12-04.
//

import SwiftUI

struct ActivityView: View {
    
    @Binding var isSheetOpen:Bool
    @StateObject var activityViewModel:ActivityViewModel
    let activityId:Int
    
    init(isSheetOpen: Binding<Bool>, activityId: Int) {
        self._isSheetOpen = isSheetOpen
        self.activityId = activityId
        self._activityViewModel = StateObject(wrappedValue: ActivityViewModel(activityId: activityId))
    }

    var body: some View {
        VStack(spacing:0) {
            LazyVStack(spacing: 0) {
                switch activityViewModel.dataState{
                case .initial:
                    LoadingView()
                        .padding(.top, 100)
                case .empty:
                    Text(NSLocalizedString("activity_not_available", comment: ""))
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
                            activityViewModel.fetchActivity(activityId: activityId)
                        } label: {
                            Text(NSLocalizedString("try_again", comment: ""))
                                .font(.caption)
                                .bold()
                        }
                    }
                    .padding()
                    .padding(.top,100)
                case .ok:
                    VStack(alignment: .leading){
                        ActivityTitleView(activity: activityViewModel.activity!, isSheetOpen: $isSheetOpen)
                            .padding(.bottom, 10)
                        if activityViewModel.activity!.endDate.isInFuture{
                            ActivityStatusView(activity: activityViewModel.activity!).padding(.bottom)
                        }
                        ActivityTimeView(activity: activityViewModel.activity!).padding(.bottom, 10)
                        ActivityFacilityView(activity: activityViewModel.activity!).padding(.bottom, 10)
                        FacilityLocationView(facility: activityViewModel.activity!.facility).padding(.bottom, 10)
                        ActivityActionView(activity: activityViewModel.activity!)
                    }
                    .padding()
                }
            }
            Spacer()
        }
        .presentationDragIndicator(.visible)
        .presentationDetents([.fraction(0.8)])
    }
}

struct ActivityDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView(isSheetOpen: .constant(Bool()), activityId: Int.zero)
    }
}
