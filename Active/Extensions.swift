//
//  Extensions.swift
//  Active
//
//  Created by Emrah on 2023-01-11.
//

import SwiftUI

extension Color{
    static let ottawaColor =  Color("OttawaColor")
    static let ottawaColorAdjusted = Color("OttawaColorAdjusted")
    static let secondaryText = Color("SecondaryTextColor")
    static let removeButtonRed = Color("RemoveButtonRed")
    static let secondaryWhite = Color("SecondaryWhite")
    static let customGreen = Color("Green")
    static let customRed = Color("Red")
    static let systemBackground = Color("systemBackground")
}

extension UINavigationController{
    open override func viewDidLoad() {
        @Environment(\.colorScheme) var colorScheme
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.systemBackground
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        
        navigationBar.largeTitleTextAttributes = [.foregroundColor: Color.secondaryText]
        navigationBar.titleTextAttributes = [.foregroundColor: Color.secondaryText]
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
    }
}

extension Date {
    
    private func dayNameOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
        
    func addDays(numberOfDays:Int)->Date{
        Calendar.current.date(byAdding: .day, value: numberOfDays, to: self)!
    }
    
    func setHour(hour:Int)->Date{
        Calendar.current.date(bySettingHour: hour, minute: 0, second: 0, of: self)!
    }
    
    static func getDate(from date:String) -> Date{
        let df:DateFormatter = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return df.date(from: date) ?? Date()
    }
    
    var localDateTimeString:String{
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter.string(from: self)
    }
    
    var isInPast: Bool{
        self < Date()
    }
    
    var isInFuture: Bool{
        self > Date()
    }
    
    var midnight: Date {
        Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
    
    var relativeDateTime: String{
        let rdtf = RelativeDateTimeFormatter()
        rdtf.dateTimeStyle = .named
        return rdtf.localizedString(fromTimeInterval: self.timeIntervalSince(Date()))
    }
    
    var weekDayName:String{
        return Calendar.current.isDateInToday(self) ?
        NSLocalizedString("today", comment: "") : Calendar.current.isDateInTomorrow(self) ?
        NSLocalizedString("tomorrow", comment: "") : self.dayNameOfWeek()
    }
    
    var time:String{
        let df = DateFormatter()
        switch getDeviceLanguage(){
        case .english:
            df.dateFormat = "h:mm a"
        case .french:
            df.dateFormat = "H 'h' mm"
        default:
            df.dateFormat = "hh:mm"
        }
        return df.string(from: self)
    }
    
    var mediumDateTime:String{
        let df = DateFormatter()
        switch getDeviceLanguage(){
        case .english:
            df.dateFormat = "MMM d, h:mm a"
        case .french:
            df.dateFormat = "MMM d, H 'h' mm"
        default:
            df.dateFormat = "MMM d, hh:mm"
        }
        return df.string(from: self)
    }
    
    var date:String{
        let df = DateFormatter()
        df.dateFormat = "EEEE, MMM d"
        return df.string(from: self)
    }
}

private func getDeviceLanguage()->Language{
    let language = Locale.current.identifier
    let languageCode = language[..<language.index(language.startIndex, offsetBy: 2)]
    switch languageCode{
    case "en":
        return .english
    case "fr":
        return .french
    default:
        return .other
    }
}

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

extension String{
  func trim() -> String{
    return self.trimmingCharacters(in: .whitespacesAndNewlines)
  }
}
