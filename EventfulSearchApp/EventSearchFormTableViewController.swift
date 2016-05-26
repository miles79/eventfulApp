//
//  EventSearchFormTableViewController.swift
//  EventfulSearchApp
//
//  Created by Miles McLeod on 2016-05-23.
//  Copyright © 2016 Miles McLeod. All rights reserved.
//

import UIKit
import ASValueTrackingSlider
import GoogleMaps
import Alamofire
import AlamofireImage
import Fuzi
import SwiftOverlays

class EventSearchFormTableViewController: UITableViewController, UISearchBarDelegate, ASValueTrackingSliderDataSource, ASValueTrackingSliderDelegate {
    // Dropdown Categories cell constans/variables
    var categoriesHidden = true
    let dateSection = 2
    let categorySection = 3
    
    // variables
    var dateRange = DateRange(startDate: NSDate(), endDate: NSDate().addDays(1) ?? NSDate()) {
        didSet {
            datesLabel.text = dateRange.startDate.readableDateAndMonth() + " to " + dateRange.endDate.readableDateAndMonth()
        }
    }
    var selectedCategory = "Music"
    var searchCoordinates : Coordinates?
    var searchRadius : Int {
        get {
            return Int(distanceSlider.value)
        }
    }
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var searchBar: UISearchBar?
    var resultView: UITextView?
    
    // Outlets
    @IBOutlet weak var findEventsBarButton: UIBarButtonItem!
    @IBOutlet weak var datesLabel: UILabel!
    @IBOutlet weak var searchBarContainerView: UIView!
    @IBOutlet weak var distanceSlider: ASValueTrackingSlider!
    
    // Actions
    @IBAction func findEventsNavButtonPressed(sender: UIBarButtonItem) {
        SwiftOverlays.showBlockingWaitOverlayWithText("Loading Events")
        EventfulAPIClient().getEvents(searchCoordinates!, searchRadius: searchRadius, dateRange: dateRange, category: selectedCategory,
                                      completionHandler: { events in
                                        SwiftOverlays.removeAllBlockingOverlays()
                                        if events.count > 0
                                        {
                                            self.performSegueWithIdentifier("eventSearchResultsSegue", sender: events)
                                        }
                                        else {
                                            SwiftOverlays.showBlockingTextOverlayWithDuration("Couldn't find any events!", duration: 2)
                                        }
            }
        )
    }
    
    // ViewController delegates
    override func viewDidLoad() {
        super.viewDidLoad()
        
        distanceSlider.dataSource = self
        distanceSlider.delegate = self
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        searchBar = searchController?.searchBar
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        self.definesPresentationContext = true
        
        searchBarContainerView.addSubview(searchBar!)
        setupSearchBar()
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = true
    }

    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        searchBar?.sizeToFit()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Slider Pop-up Delegates
    func sliderWillDisplayPopUpView(slider: ASValueTrackingSlider!) {
        //TODO: deal with table cell overlap
    }
    
    func slider(slider: ASValueTrackingSlider!, stringForValue value: Float) -> String! {
        return String(format: "%.0f", value) + " km"
    }
    
    // SearchBar Delegates
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.updateFindEventsButton(searchBar)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.updateFindEventsButton(searchBar)
    }
    
    // Tableview Delegates
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == categorySection && indexPath.row != 0 {
            let height:CGFloat = categoriesHidden ? 0.0 : 44.0
            return height
        }
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 && indexPath.section == dateSection {
            performSegueWithIdentifier("calendarModalSegue", sender: nil)
            self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        }

        if indexPath.section == categorySection {
            if indexPath.row == 0 {
                categoriesHidden = !categoriesHidden
            }
            else {
                selectedCategory = (tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text)!
                tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: categorySection))?.textLabel?.text = selectedCategory
                categoriesHidden = true
            }
            UIView.animateWithDuration(0.3, animations:  {() -> Void in
                tableView.beginUpdates()
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
                tableView.endUpdates()
            })
        }
    }
    
    // Navigation
    @IBAction func unwindToEventSearchForm(segue: UIStoryboardSegue) {
        if let calendarViewController = segue.sourceViewController as? CalendarViewController {
            
            if let startDate = calendarViewController.rangeUnderEdit?.beginDate,
                endDate = calendarViewController.rangeUnderEdit?.endDate {
                dateRange.startDate = startDate
                dateRange.endDate = endDate
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "calendarModalSegue" {
            if let calendarViewController = segue.destinationViewController as? CalendarViewController {
                calendarViewController.defaultStartDate = dateRange.startDate
                calendarViewController.defaultEndDate = dateRange.endDate
            }
        }
        if segue.identifier == "eventSearchResultsSegue" {
            if let eventSearchResultsViewController = segue.destinationViewController as? EventSearchResultsViewController,
                let events = sender as? [Event] {
                eventSearchResultsViewController.events = events
            }
        }
    }
    
    // Helpers
    private func updateFindEventsButton(searchBar: UISearchBar) {
        if (searchBar.text ?? "").isEmpty {
            self.navigationItem.rightBarButtonItem?.enabled = false
            self.searchCoordinates = nil
        }
        else {
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
    }
    
    private func setupSearchBar() {
        searchBar?.placeholder = "Location"
        searchBar?.delegate = self
        searchBar?.sizeToFit()
        self.navigationItem.rightBarButtonItem?.enabled = false
    }
}

    // Handle the user's selection.
    extension EventSearchFormTableViewController: GMSAutocompleteResultsViewControllerDelegate {
        func resultsController(resultsController: GMSAutocompleteResultsViewController,
                               didAutocompleteWithPlace place: GMSPlace) {
            searchController?.active = false

            searchBar?.text = place.formattedAddress
            searchCoordinates = Coordinates(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        }
        
        func resultsController(resultsController: GMSAutocompleteResultsViewController,
                               didFailAutocompleteWithError error: NSError){
            // TODO: handle the error.
            print("Error: ", error.description)
        }
        
        // Turn the network activity indicator on and off again.
        func didRequestAutocompletePredictionsForResultsController(resultsController: GMSAutocompleteResultsViewController) {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        }
        
        func didUpdateAutocompletePredictionsForResultsController(resultsController: GMSAutocompleteResultsViewController) {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
}