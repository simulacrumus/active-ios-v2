//
//  ActivitySortSheetView.swift
//  Active
//
//  Created by Emrah on 2023-04-13.
//

import SwiftUI

struct ActivitySortSheetView: View {
    @Binding var isSheetOpen:Bool
    @Binding var selectedOption:ActivitySortOption
    @Binding var selectedSortEnum:ActivitySortEnum
    let options:[ActivitySortOption]

    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            HStack(spacing: 0){
                Text(NSLocalizedString("sort_by", comment: ""))
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
                                selectedSortEnum = option.sortEnum
                            }
                        }, label: {
                            HStack{
                                Text(option.subtitle)
                                    .font(.body)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                Image(systemName: option.sortEnum == selectedSortEnum ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(option.sortEnum == selectedSortEnum  ? .accentColor : .primary)
                                    .font(.title3)
                            }
                        })
                        .padding(10)
                        .foregroundColor(.primary)
                    }
                }
            }
            .scrollIndicators(.visible)
        }
        .presentationDragIndicator(.automatic)
        .padding()
        .presentationDetents([.fraction(0.25)])
    }
}

struct ActivitySortSheetView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitySortSheetView(isSheetOpen: .constant(Bool()), selectedOption: .constant(ActivitySortOption(sortEnum: .none, title: String(), subtitle: String())), selectedSortEnum: .constant(.none), options: [ActivitySortOption]())
    }
}
