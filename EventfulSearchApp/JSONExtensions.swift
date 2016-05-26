//
//  JSONExtensions.swift
//  EventfulSearchApp
//
//  Created by Miles McLeod on 2016-05-25.
//  Copyright © 2016 Miles McLeod. All rights reserved.
//

import SwiftyJSON

extension JSON {
    func mapToEvent() -> Event {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            if let
                title = self["title"].string,
                venue = self["venue_name"].string,
                startDateTime = formatter.dateFromString(self["start_time"].string!),
            {
                if let startDateTimeString = self["start_time"].string {
                    endDate formatter.dateFromString(startDateTimeString)
                }
                
                return Event(title: title, venue: venue, performers: nil, startDateTime: startDateTime, endDateTime: endDateTime)
            }
            else {
                debugPrint("bad json \(self)")
                return nil
            }
    }
}