//
//  Extentions.swift
//  VolleyBallStatistic(SwiftUI)
//
//  Created by Roman Yarmoliuk on 24.04.2023.
//

import Foundation
import SwiftUI

extension Color {
    
    public static let myDarkGreen: Color = Color(UIColor(red: 0.1843, green: 0.6039, blue: 0.3529, alpha: 1))
    public static let myLightGreen: Color = Color(UIColor(red: 0, green: 0.8392, blue: 0.5843, alpha: 1))
    public static let myYellow: Color = Color(UIColor(red: 1, green: 0.7782, blue: 0.1961, alpha: 1))
    public static let myGreen: Color = Color(UIColor(red: 0.149, green: 0.6471, blue: 0.3961, alpha: 1))
    public static let myWhite: Color = Color(UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1))
    public static let myDarkGray: Color = Color(UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1))
    public static let mySegmentBG: Color = Color(UIColor(red: 17/255, green: 134/255, blue: 87/255, alpha: 1))
    public static let myBlack: Color = Color(UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1))
    
    public static var myRandomGreen: Color {
        let redValue = Double.random(in: 0.2...0.65)
        let blueValue = Double.random(in: 0.2...0.65)
        let greenValue = Double.random(in: 0.8...0.9)
        return Color(red: redValue, green: greenValue, blue: blueValue)
    }
}

extension Date {
    func isSameDay(as date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(self, inSameDayAs: date)
    }
}

extension String {
    func firstChar() -> String {
        self.isEmpty ? "" : String(self.first!)
    }
}
