//
//  ActivityListItemView.swift
//  Active
//
//  Created by Emrah on 2023-01-06.
//

import SwiftUI

struct ActivityListItemView: View {
    let activity: Activity
    @State private var isSheetPresented:Bool = false
    var body: some View {
        Button {
            isSheetPresented.toggle()
        } label: {
            VStack{
                HStack {
                    Text(activity.startAndEndTimeWithDay)
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.secondaryText)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    if activity.endDate > Date(){
                        Image(systemName: activity.isAvailable ?? false ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .font(.caption2)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(Color.secondaryWhite, activity.isAvailable ?? false ? Color.customGreen : Color.customRed)
                    }
                }.padding(.bottom,1)
                HStack{
                    Text(activity.title)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }.padding(.bottom,1)
                HStack{
                    Text(activity.facility.title)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Text(activity.facility.distanceString)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding()
            .cornerRadius(10)
            .buttonStyle(.plain)
        }
        .sheet(isPresented: $isSheetPresented) {
            ActivityView(isSheetOpen: $isSheetPresented, activityId: activity.id)
        }
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
    }
}

struct ActivityListItem_Previews: PreviewProvider {
    static var previews: some View {
        ActivityListItemView(activity:Activity.sample())
    }
}
