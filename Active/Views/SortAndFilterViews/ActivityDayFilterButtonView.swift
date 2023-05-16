//
//  ActivityDayFilterButtonView.swift
//  Active
//
//  Created by Emrah on 2023-04-14.
//

import SwiftUI

struct ActivityDayFilterButtonView: View {
    @State var isSheetOpen:Bool=false
    @State var selectedOption:ActivityDayFilterOption = ActivityDayFilterOption.placeholder()
    @Binding var selectedDay:Date?
    let options:[ActivityDayFilterOption] = ActivityDayFilterOption.days()
    
    var body: some View {
        HStack{
            Button {
                isSheetOpen.toggle()
            } label: {
                HStack {
                    Text(selectedOption.title)
                        .font(.caption)
                        .foregroundColor(selectedOption.id == -1 ? .gray : .white)
                        .id(selectedOption.id)
                        .animation(Animation.linear(duration: 0.3).delay(0.3), value: selectedOption.id)
                    Image(systemName: "chevron.down")
                        .foregroundColor(selectedOption.id == -1 ? .gray : .white)
                        .font(.caption)
                        .animation(Animation.linear(duration: 0.3), value: selectedOption.id)
                }
                .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
                .background(selectedOption.id == -1 ? Color.clear : Color.ottawaColorAdjusted)
                .cornerRadius(50)
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(selectedOption.id == -1 ? Color.gray : Color.ottawaColorAdjusted, lineWidth: 1)
                    )
            }
            .sheet(isPresented: $isSheetOpen){
                ActivityDayFilterSheetView(isSheetOpen: $isSheetOpen, selectedOption: $selectedOption, selectedDay: $selectedDay, options: options)
            }
            .transaction { transaction in
                transaction.animation = Animation.linear(duration: 0.3)
            }
        }.padding(.vertical, 1)
    }
}

struct ActivityDayFilterButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDayFilterButtonView(isSheetOpen: false, selectedOption: ActivityDayFilterOption.placeholder(), selectedDay: .constant(Date()))
    }
}
