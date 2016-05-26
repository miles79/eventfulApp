//
//  Models.swift
//  EventfulSearchApp
//
//  Created by Miles McLeod on 2016-05-25.
//  Copyright © 2016 Miles McLeod. All rights reserved.
//

import Foundation
import Fuzi
import Alamofire

class Event {
    var title: String
    var venue: String
    var startDateTime: NSDate
    var thumbnailImageURL: String?
    var thumbnailImage: UIImage?
    var performers: [String]
    
    init(title: String, venue: String, startDateTime: NSDate, thumbnailImageURL: String?, performers: [String]) {
        self.title = title
        self.venue = venue
        self.startDateTime = startDateTime
        self.thumbnailImageURL = thumbnailImageURL
        self.performers = performers
    }
}

extension Event {
    class func fromXML(xmlElement:XMLElement) -> Event {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let title = xmlElement.firstChild(tag: "title")!.stringValue
        let venue = xmlElement.firstChild(tag: "venue_name")!.stringValue
        let startDateTime = formatter.dateFromString((xmlElement.firstChild(tag: "start_time")?.stringValue)!)!
        let thumbnailImageURL = xmlElement.firstChild(tag: "image")?.firstChild(tag: "thumb")?.firstChild(tag: "url")?.stringValue
        let performers = xmlElement.firstChild(tag: "performers")?.children(tag: "performer").map({ $0.firstChild(tag: "name")!.stringValue }) ?? [String]()
        
        if thumbnailImageURL != nil {
         print(title + " " + thumbnailImageURL!)
        }
        
        return Event(title: title, venue: venue, startDateTime: startDateTime, thumbnailImageURL: thumbnailImageURL, performers: performers)
    }
}

struct DateRange {
    var startDate: NSDate
    var endDate: NSDate
}

extension DateRange {
    func toEventfulDateRangeFormat() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd00"
        
        let formattedStartDate = dateFormatter.stringFromDate(self.startDate)
        let formattedEndDate = dateFormatter.stringFromDate(self.endDate)
        
        return "\(formattedStartDate)-\(formattedEndDate)"
    }
}

struct Coordinates {
    var latitude: Double
    var longitude: Double
}

extension Coordinates {
    func toEventfulLocationFormat() -> String {
        return "\(self.latitude),\(self.longitude)"
    }
}