//
//  EventSearchResultsViewController.swift
//  EventfulSearchApp
//
//  Created by Miles McLeod on 2016-05-24.
//  Copyright © 2016 Miles McLeod. All rights reserved.
//

import UIKit

class EventSearchResultsViewController: UITableViewController {

    // MARK: Properties
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "EventTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! EventTableViewCell
        
        let event = events[indexPath.row]
        cell.titleLabel.text = event.title
        cell.venueLabel.text = event.venue
        cell.dateLabel.text = event.startDateTime.readableDateAndMonth()
        if let thumbnailImage = event.thumbnailImage {
            cell.thumbnailImage.image = thumbnailImage
        }
        cell.performersLabel.text = String(event.performers.joinWithSeparator(", ").characters.dropLast())
        
        return cell
    }
    
}
