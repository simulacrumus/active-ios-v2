//
//  WalkthroughPage.swift
//  Active
//
//  Created by Emrah on 2023-01-30.
//

import Foundation

struct WalkthroughPage:Identifiable{
    var id:Int
    var imageText:String
    var titleText:String
    var bodyText:String
    
    static var pages:[WalkthroughPage] = [
        WalkthroughPage(
            id: 1,
            imageText: "figure.run.circle.fill",
            titleText: NSLocalizedString("welcome_to_active", comment: ""),
            bodyText: NSLocalizedString("walkthrough_page_1", comment: "")
        ),
        WalkthroughPage(
            id: 2,
            imageText: "info.circle.fill",
            titleText: NSLocalizedString("disclaimer", comment: ""),
            bodyText: NSLocalizedString("walkthrough_page_2", comment: "")
        ),
        WalkthroughPage(
            id: 3,
            imageText: "location.circle.fill",
            titleText: NSLocalizedString("location", comment: ""),
            bodyText: NSLocalizedString("walkthrough_page_3", comment: "")
        ),
        WalkthroughPage(
            id: 4,
            imageText: "hand.thumbsup.circle.fill",
            titleText: NSLocalizedString("review", comment: ""),
            bodyText: NSLocalizedString("walkthrough_page_4", comment: "")
        )
    ]
}
