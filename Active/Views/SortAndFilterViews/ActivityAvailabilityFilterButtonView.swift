//
//  ActivityAvailabilityFilterButtonView.swift
//  Active
//
//  Created by Emrah on 2023-04-13.
//

import SwiftUI

struct ActivityAvailabilityFilterButtonView: View {
    @Binding var isAvailable:Bool?
    
    var body: some View {
        HStack{
            Button {
                isAvailable = isAvailable ?? false ? nil : true
            } label: {
                Text(NSLocalizedString("available", comment: ""))
                    .font(.caption)
                    .foregroundColor(isAvailable ?? false ? .white : .gray)
                    .id(isAvailable)
                    .animation(Animation.linear(duration: 0.3).delay(0.3), value: isAvailable)
                    .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
                    .background(isAvailable ?? false ? Color.ottawaColorAdjusted : .clear)
                    .cornerRadius(50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(isAvailable ?? false ? Color.ottawaColorAdjusted : .gray, lineWidth: 1)
                        )
            }
            .transaction { transaction in
                transaction.animation = Animation.linear(duration: 0.3)
            }
        }
        .padding(.vertical,1)
    }
}

struct ActivityAvailabilityFilterButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityAvailabilityFilterButtonView(isAvailable: .constant(Bool()))
    }
}
