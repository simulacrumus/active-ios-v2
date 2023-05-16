//
//  ActivityFilterByFacilitySheetView.swift
//  Active
//
//  Created by Emrah on 2023-04-14.
//

import SwiftUI

struct ActivityFilterByFacilitySheetView: View {
    @Binding var isSheetOpen:Bool
    @Binding var selectedOption:ActivityFilterByFaciltyOption
    @Binding var selectedFacilityId:Int
    let options:[ActivityFilterByFaciltyOption]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            HStack(spacing: 0){
                Text(NSLocalizedString("select_facility", comment: ""))
                    .font(.title3)
                    .bold()
                Spacer()
                Button{
                    isSheetOpen=false
                }label:{
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 30))
                        .foregroundStyle(.gray, Color(UIColor.systemGray5))
                }
            }
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 2))
            ScrollView(.vertical, showsIndicators: true){
                LazyVStack(spacing: .zero){
                    ForEach(options.filter({ option in
                        option.id != 0 && option.id != -1
                    })) { option in
                        Button(action: {
                            isSheetOpen=false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                selectedOption = option
                                selectedFacilityId = option.id
                            }
                        }, label: {
                            HStack{
                                Text(option.subtitle)
                                    .font(.body)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                Image(systemName: option.id == selectedOption.id ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(option.id == selectedOption.id   ? .accentColor : .primary)
                                    .font(.title3)
                            }
                        })
                        .padding(10)
                        .foregroundColor(.primary)
                    }
                }
            }
            .scrollIndicators(.visible)
            if selectedOption.id != Int.zero{
                Button{
                    isSheetOpen=false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        selectedOption = ActivityFilterByFaciltyOption.placeholder()
                        selectedFacilityId = ActivityFilterByFaciltyOption.placeholder().id
                    }
                } label: {
                    HStack{
                        Spacer()
                        Text(NSLocalizedString("clear_selection", comment: ""))
                            .foregroundColor(.white)
                            .bold()
                            .font(.subheadline)
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    .background(Color.removeButtonRed)
                    .cornerRadius(5)
                }
                .padding(10)
            }
        }
        .presentationDragIndicator(.automatic)
        .padding()
    }
}

struct ActivityFilterByFacilitySheetView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityFilterByFacilitySheetView(isSheetOpen: .constant(Bool()), selectedOption: .constant(ActivityFilterByFaciltyOption.placeholder()), selectedFacilityId: .constant(Int()), options: [ActivityFilterByFaciltyOption]())
    }
}
