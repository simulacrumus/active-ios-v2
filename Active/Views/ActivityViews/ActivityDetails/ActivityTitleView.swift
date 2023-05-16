//
//  ActivityTitleView.swift
//  Active
//
//  Created by Emrah on 2023-04-17.
//

import SwiftUI

struct ActivityTitleView: View {
    let activity:Activity
    @Binding var isSheetOpen:Bool
    
    var body: some View {
        VStack (spacing:0){
            HStack{
                Text("\(activity.category) • \(activity.type)")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
                Button {
                    isSheetOpen = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 30))
                        .foregroundStyle(.gray, Color(UIColor.systemGray5))
                }
            }
            .padding(.top)
            .padding(.bottom, 10)
            HStack{
                Text(activity.title)
                    .font(.title3)
                    .foregroundColor(.secondaryText)
                    .multilineTextAlignment(.leading)
                    .bold()
                Spacer()
            }
        }
    }
}

struct ActivityTitleView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityTitleView(activity: Activity.sample(), isSheetOpen: .constant(Bool()))
    }
}
