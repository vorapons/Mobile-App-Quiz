//
//  Extension_Date.swift
//  AppQuiz
//
//  Created by Vorapon Sirimahatham on 8/7/21.
//

import Foundation

extension Date {
    func convertToTimeZone(initTimeZone: TimeZone, timeZone: TimeZone) -> Date {
         let delta = TimeInterval(timeZone.secondsFromGMT(for: self) - initTimeZone.secondsFromGMT(for: self))
         return addingTimeInterval(delta)
    }
    
    func convertUTCtoCurrentTimezone() -> Date {
        if let initTimeZone = TimeZone.init(abbreviation: "UTC") {
            let timeZone = TimeZone.current
            let delta = TimeInterval(timeZone.secondsFromGMT(for: self) - initTimeZone.secondsFromGMT(for: self))
            return addingTimeInterval(delta)
        }
        else {
            return Date()
        }
    }
     
    
}
