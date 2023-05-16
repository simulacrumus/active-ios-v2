//
//  FacilitySortAndFilterBarView.swift
//  Active
//
//  Created by Emrah on 2022-12-08.
//

import SwiftUI

struct FacilitySortAndFilterBarView: View {
    @Binding var selectedSortEnum:FacilitySortEnum
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack{
                HStack{}.padding([.leading])
                FacilitySortButtonView(selectedSortEnum: $selectedSortEnum)
                Spacer()
                HStack{}.padding([.leading], 10)
            }
        }
        .statusBarHidden(true)
    }
}

struct FacilitySearchOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        FacilitySortAndFilterBarView(selectedSortEnum: .constant(.none))
    }
}
