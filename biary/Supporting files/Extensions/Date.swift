//
//  Date.swift
//  biary
//
//  Created by 이창현 on 01/03/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import Foundation
import UIKit


func weekdayToString(week:Int) -> String{
    switch week {
    case 1:
        return "일"
    case 2:
        return "월"
    case 3:
        return "화"
    case 4:
        return "수"
    case 5:
        return "목"
    case 6:
        return "금"
    case 7:
        return "토"
        
    default:
        return ""
    }
}


//http://www.iostutorialjunction.com/2017/06/convert-date-to-time-ago-in-swift-3.html
extension Date {
    func getRealDate() -> String {
        let date = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from:date as Date)
        return dateString
    }
    
    
    func getDate() -> String {
        
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second, .weekday], from: self, to: Date())
        
        let cal = Calendar(identifier: .gregorian)
        if let comps = cal.dateComponents([.weekday,.year,.month,.day,.hour], from: self) as DateComponents?{
            if (interval.month! > 11) {
                return "\(comps.year!). \(comps.month!). \(comps.day!)"
            } else if let weak = interval.day,Double(weak)/7.0 > 1.0 {
                return "\(comps.month!). \(comps.day!)"
            } else if let day = interval.day, day > 0 {
                return "\(weekdayToString(week: comps.weekday!))"
            } else if let hour = interval.hour, hour > 0 {
                return "\(hour)시간 전"
            } else if let minute = interval.minute, minute > 0 {
                return "\(minute)분 전"
            } else {
                return "방금 전"
            }
            
            
        }
        
        return ""
    }
}

