//
//  EventfulWebService.swift
//  EventfulSearchApp
//
//  Created by Miles McLeod on 2016-05-24.
//  Copyright © 2016 Miles McLeod. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import GoogleMaps

class EventfulAPIClient {
    var appKey = "nZ3dbXDZRq9tsR2g"
    let eventSearchURL = "http://api.eventful.com/rest/events/search?"
    let distanceUnits = "km"
    
    func getEvents(location: Coordinates, searchRadius: Int, dateRange: DateRange, category: String, completionHandler: ([Event] -> Void)) {
        var events = [Event]()
        
        Alamofire.request(.GET, eventSearchURL, parameters:
            ["app_key": appKey,
                "where": location.toEventfulLocationFormat(),
                "within": searchRadius,
                "units": distanceUnits,
                "date": dateRange.toEventfulDateRangeFormat(),
                "category": category.toEventfulCategoryFormat(),
                "include":"price",
                "image_sizes":"thumb"])
            .responseXMLDocument({ response in
                if response.result.isSuccess {
                    print(response.request?.URLString)
                    let xmlResponseDocument = response.result.value!
                    
                    for element in (xmlResponseDocument.firstChild(xpath: "events")?.children)! {
                        events.append(Event.fromXML(element))
                    }
                    for var event in events {
                        if let thumbnailImageURL = event.thumbnailImageURL {
                            self.getImageFromURL(thumbnailImageURL, successCompletion: { event.thumbnailImage = $0 })
                        }
                    }
                }
                completionHandler(events)
            })
    }
    
    func getImageFromURL(imageURL: String, successCompletion: (Image -> Void)) {
        
        Alamofire.request(.GET, imageURL)
            .responseImage { response in
                if let image = response.result.value {
                    successCompletion(image)
                }
        }
    }
}

private extension String {
    func toEventfulCategoryFormat() -> String {
        return self.stringByReplacingOccurrencesOfString(" ", withString: "_").lowercaseString
    }
}