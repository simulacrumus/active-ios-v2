//
//  ActivityTypeSortAndFilterBarView.swift
//  Active
//
//  Created by Emrah on 2022-12-15.
//

import SwiftUI

struct ActivityTypeSortAndFilterBarView: View {

    @Binding var facilities:[Facility]
    @Binding var selectedSortEnum:ActivitySortEnum
    @Binding var selectedFacilityId:Int
    @Binding var isAvailable:Bool?
    @Binding var date:Date?
    
    let activityType:ActivityType
    private var filterOptions:[ActivityFilterByFaciltyOption]
    
    init(facilities: Binding<[Facility]>, selectedSortEnum: Binding<ActivitySortEnum>, selectedFacilityId: Binding<Int>,isAvailable: Binding<Bool?>, activityType:ActivityType, date:Binding<Date?>) {
        self._selectedSortEnum = selectedSortEnum
        self._selectedFacilityId = selectedFacilityId
        self._facilities = facilities
        self._isAvailable = isAvailable
        self._date = date
        self.activityType = activityType
        self.filterOptions = facilities.map({ facility in
            ActivityFilterByFaciltyOption(id: facility.id, title: facility.wrappedValue.title, subtitle: facility.wrappedValue.title)
        })
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack{
                HStack{}.padding([.leading])
                ActivitySortButtonView(selectedSortEnum: $selectedSortEnum)
                ActivityDayFilterButtonView(selectedDay: $date)
                if date != nil {
                    ActivityTimeFilterButtonView(selectedDay: $date)
                }
                ActivityFilterByFacilityButtonView(selectedFacilityId: $selectedFacilityId, options: filterOptions)
                ActivityAvailabilityFilterButtonView(isAvailable: $isAvailable)
                Spacer()
                HStack{}.padding([.leading], 10)
            }
        }
    }
}

struct ActivityTypeSortAndFilterBar_Previews: PreviewProvider {
    static var previews: some View {
        ActivityTypeSortAndFilterBarView(facilities: .constant([Facility]()), selectedSortEnum: .constant(ActivitySortEnum.distance), selectedFacilityId: .constant(Int.zero), isAvailable: .constant(Bool()), activityType: ActivityType.sample(), date: .constant(Date()))
    }
}
