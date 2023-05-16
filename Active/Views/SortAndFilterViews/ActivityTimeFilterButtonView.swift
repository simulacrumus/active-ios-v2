//
//  ActivityTimeFilterButtonnView.swift
//  Active
//
//  Created by Emrah on 2023-04-15.
//

import SwiftUI

struct ActivityTimeFilterButtonView: View {
    @State var isSheetOpen:Bool=false
    @State var selectedOption:ActivityTimeFilterOption = ActivityTimeFilterOption.placeholder()
    @Binding var selectedDay:Date?
    var body: some View {
        HStack{
            Button {
                isSheetOpen.toggle()
            } label: {
                HStack {
                    Text(selectedOption.title)
                        .font(.caption)
                        .foregroundColor(selectedOption.id == Int.zero ? .gray : .white)
                        .id(selectedOption.id)
                        .animation(Animation.linear(duration: 0.3).delay(0.3), value: selectedOption.id)
                    Image(systemName: "chevron.down")
                        .foregroundColor(selectedOption.id == Int.zero ? .gray : .white)
                        .font(.caption)
                        .animation(Animation.linear(duration: 0.3), value: selectedOption.id)
                }
                .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
                .background(selectedOption.id == Int.zero ? Color.clear : Color.ottawaColorAdjusted)
                .cornerRadius(50)
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(selectedOption.id == Int.zero ? Color.gray : Color.ottawaColorAdjusted, lineWidth: 1)
                    )
            }
            .disabled(selectedDay == nil)
            .sheet(isPresented: $isSheetOpen){
                ActivityTimeFilterSheetView(isSheetOpen: $isSheetOpen, selectedOption: $selectedOption, selectedDay: $selectedDay)
            }
            .transaction { transaction in
                transaction.animation = Animation.linear(duration: 0.3)
            }
        }
        .padding(.vertical, 1)
        .onChange(of: selectedDay) { newValue in
            if newValue == newValue?.midnight{
                selectedOption = ActivityTimeFilterOption.placeholder()
            }
        }
    }    
}

struct ActivityTimeFilterButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityTimeFilterButtonView(isSheetOpen: Bool(), selectedOption: ActivityTimeFilterOption.placeholder(), selectedDay: .constant(Date()))
    }
}
