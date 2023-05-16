//
//  ActivitySortOptionview.swift
//  Active
//
//  Created by Emrah on 2023-04-13.
//

import SwiftUI

struct ActivitySortButtonView: View {
    
    @State var isSheetOpen:Bool=false
    @State var selectedOption:ActivitySortOption = ActivitySortOption.options().first!
    @Binding var selectedSortEnum:ActivitySortEnum
    let options:[ActivitySortOption] = ActivitySortOption.options()
    
    var body: some View {
        HStack{
            Button {
                isSheetOpen.toggle()
            } label: {
                HStack {
                    Text(selectedOption.title)
                        .font(.caption)
                        .foregroundColor(selectedOption.sortEnum == .none ? .gray : .white)
                        .id(selectedOption.id)
                        .animation(Animation.linear(duration: 0.3).delay(0.3), value: selectedOption.id)
                    Image(systemName: "chevron.down")
                        .foregroundColor(selectedOption.sortEnum == .none ? .gray : .white)
                        .font(.caption)
                        .animation(Animation.linear(duration: 0.3), value: selectedOption.id)
                }
                .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
                .background(selectedOption.sortEnum == .none ? Color.clear : Color.ottawaColorAdjusted)
                .cornerRadius(50)
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(selectedOption.sortEnum == .none ? Color.gray : Color.ottawaColorAdjusted, lineWidth: 1)
                    )
            }
            .sheet(isPresented: $isSheetOpen){
                ActivitySortSheetView(isSheetOpen: $isSheetOpen, selectedOption: $selectedOption, selectedSortEnum: $selectedSortEnum, options: options)
            }
            .transaction { transaction in
                transaction.animation = Animation.linear(duration: 0.3)
            }
        }.padding(.vertical, 1)
    }
}

struct ActivitySortButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitySortButtonView(selectedSortEnum: .constant(ActivitySortEnum.none))
    }
}
