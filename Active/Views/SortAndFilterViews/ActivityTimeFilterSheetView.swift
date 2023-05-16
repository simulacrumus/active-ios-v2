//
//  ActivityTimeFilterSheetView.swift
//  Active
//
//  Created by Emrah on 2023-04-15.
//

import SwiftUI

struct ActivityTimeFilterSheetView: View {
    @Binding var isSheetOpen:Bool
    @Binding var selectedOption:ActivityTimeFilterOption
    @Binding var selectedDay:Date?
    @State var options:[ActivityTimeFilterOption] = ActivityTimeFilterOption.options()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            HStack(spacing: 0){
                Text(NSLocalizedString("set_time", comment: ""))
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
                    ForEach(options) { option in
                        Button(action: {
                            isSheetOpen=false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                selectedOption = option
                                selectedDay = selectedDay?.setHour(hour: option.id)
                            }
                        }, label: {
                            HStack{
                                Text(option.subtitle)
                                    .font(.body)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                Image(systemName: option.id == selectedOption.id ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(option.id == selectedOption.id ? .accentColor : .primary)
                                    .font(.title3)
                            }
                        })
                        .padding(10)
                        .foregroundColor(.primary)
                    }
                }
            }
            if selectedOption.id != Int.zero{
                Button{
                    isSheetOpen=false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        selectedOption = ActivityTimeFilterOption.placeholder()
                        selectedDay = selectedDay?.midnight
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

struct ActivityTimeFilterSheetView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityTimeFilterSheetView(isSheetOpen: .constant(Bool()), selectedOption: .constant(ActivityTimeFilterOption.placeholder()), selectedDay: .constant(Date()), options: [ActivityTimeFilterOption]())
    }
}
