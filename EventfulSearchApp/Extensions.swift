//
//  Extensions.swift
//  EventfulSearchApp
//
//  Created by Miles McLeod on 2016-05-25.
//  Copyright © 2016 Miles McLeod. All rights reserved.
//

import Foundation

import Foundation
import Fuzi
import Alamofire

extension Event {
    class func fromXML(xmlElement:XMLElement) -> Event {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let title = xmlElement.firstChild(tag: "title")!.stringValue
        let venue = xmlElement.firstChild(tag: "venue_name")!.stringValue
        let startDateTime = formatter.dateFromString((xmlElement.firstChild(tag: "start_time")?.stringValue)!)!
        let thumbnailImageURL = xmlElement.firstChild(tag: "image")?.firstChild(tag: "thumb")?.firstChild(tag: "url")?.stringValue
        
        return Event(title: title, venue: venue, startDateTime: startDateTime, thumbnailImageURL: thumbnailImageURL)
    }
}