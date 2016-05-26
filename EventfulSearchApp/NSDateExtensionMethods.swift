//
//  NSDateExtensionMethods.swift
//  EventfulSearchApp
//
//  Created by Miles McLeod on 2016-05-24.
//  Copyright © 2016 Miles McLeod. All rights reserved.
//

import Foundation

extension NSDate {
    func readableDateAndMonth() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMMM d"
        
        return formatter.stringFromDate(self)
    }
    
    func compareDateOnly(toDate: NSDate) -> NSComparisonResult {
        return NSCalendar.currentCalendar().compareDate(self, toDate: toDate, toUnitGranularity: .Day)
    }
    
    func addDays(numberOfDays: Int) -> NSDate? {
        return NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: numberOfDays, toDate: self, options: [])
    }
    
    func daysFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Day, fromDate: self, toDate: date, options: []).day
    }
}