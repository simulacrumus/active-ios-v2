//
//  ActivityFilterByFacilityButtonView.swift
//  Active
//
//  Created by Emrah on 2023-04-14.
//

import SwiftUI

struct ActivityFilterByFacilityButtonView: View {
    @State var isSheetOpen:Bool=false
    @State var selectedOption:ActivityFilterByFaciltyOption = ActivityFilterByFaciltyOption.placeholder()
    @Binding var selectedFacilityId:Int
    let options:[ActivityFilterByFaciltyOption]
    
    var body: some View {
        HStack{
            Button {
                isSheetOpen.toggle()
            } label: {
                HStack {
                    Text(selectedOption.title)
                        .font(.caption)
                        .foregroundColor(selectedOption.id == 0 ? .gray : .white)
                        .id(selectedOption.id)
                        .animation(Animation.linear(duration: 0.3).delay(0.3), value: selectedOption.id)
                    Image(systemName: "chevron.down")
                        .foregroundColor(selectedOption.id == 0 ? .gray : .white)
                        .font(.caption)
                        .animation(Animation.linear(duration: 0.3), value: selectedOption.id)
                }
                .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
                .background(selectedOption.id == 0 ? Color.clear : Color.ottawaColorAdjusted)
                .cornerRadius(50)
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(selectedOption.id == 0 ? Color.gray : Color.ottawaColorAdjusted, lineWidth: 1)
                    )
            }
            .sheet(isPresented: $isSheetOpen){
                ActivityFilterByFacilitySheetView(isSheetOpen: $isSheetOpen, selectedOption: $selectedOption, selectedFacilityId: $selectedFacilityId, options: options)
            }
            .transaction { transaction in
                transaction.animation = Animation.linear(duration: 0.3)
            }
        }.padding(.vertical, 1)
    }
}

struct ActivityFilterByFacilityButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityFilterByFacilityButtonView(selectedFacilityId: .constant(Int()), options: [ActivityFilterByFaciltyOption]())
    }
}
