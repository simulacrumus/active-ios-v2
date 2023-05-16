//
//  ContentView.swift
//  Active
//
//  Created by Emrah on 2022-11-24.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject var favorites:Favorites = Favorites()
    @StateObject var schedule:Schedule = Schedule()
    @AppStorage("walkthrough_current_pagee") private var currentPage = 1
    
    init() {
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
    }
    
    var body: some View {
        if currentPage <= WalkthroughPage.pages.count{
            WalkthroughView(currentPage: $currentPage)
        } else {
            TabBarView()
                .environmentObject(self.favorites)
                .environmentObject(self.schedule)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView().colorScheme(.dark)
    }
}
