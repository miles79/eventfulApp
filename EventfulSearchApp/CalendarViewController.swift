//
//  CalendarViewController.swift
//  EventfulSearchApp
//
//  Created by Miles McLeod on 2016-05-23.
//  Copyright © 2016 Miles McLeod. All rights reserved.
//

import UIKit
import GLCalendarView
import Toast_Swift

class CalendarViewController: UIViewController, GLCalendarViewDelegate {
    
    // Mark: - Constants
    struct Constants {
        static let maximumDateRange = 28
    }
    let outOfRangeMinToastMessage = "You can't search for events in the past!"
    let outOfRangeMaxToastMessage = "The maximum search range is \(Constants.maximumDateRange) days"
    let rangeColor = UIColor.orangeColor()
    
    // Mark: - Variables
    var defaultStartDate = NSDate()
    var defaultEndDate = NSDate()
    var rangeUnderEdit: GLCalendarDateRange?
    
    // Mark: - Outlets
    @IBOutlet weak var setDatesButton: UIButton!
    @IBOutlet weak var calendarView: GLCalendarView!
    @IBOutlet weak var dateRangeLabel: UILabel!
    
    // Mark: - CalendarView Delegates
    @IBAction func clearCalendarButtonPressed(sender: UIButton) {
        calendarView.removeRange(rangeUnderEdit)
        rangeUnderEdit = nil
        calendarView.reload()
        setDatesButton.enabled = false
        dateRangeLabel.text = ""
    }
    
    @IBAction func setDatesPressed(sender: UIButton) {
        self.performSegueWithIdentifier("unwindToEventSearchForm", sender: sender)
    }
    
    @IBAction func cancelPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Calendar Delegates
    func calenderView(calendarView: GLCalendarView!, beginToEditRange range: GLCalendarDateRange!) {
    }
    func calenderView(calendarView: GLCalendarView!, canAddRangeWithBeginDate beginDate: NSDate!) -> Bool {
        let today = NSDate()
        
        if beginDate.compareDateOnly(today) == .OrderedAscending {
            makeCenteredToast(outOfRangeMinToastMessage)
            return false
        }
        return true
    }
    func calenderView(calendarView: GLCalendarView!, finishEditRange range: GLCalendarDateRange!, continueEditing: Bool) {
    }
    func calenderView(calendarView: GLCalendarView!, rangeToAddWithBeginDate beginDate: NSDate!) -> GLCalendarDateRange! {
        if rangeUnderEdit == nil {
            setDatesButton.enabled = true
            let range = GLCalendarDateRange(beginDate: beginDate, endDate: beginDate)
            range.backgroundColor = rangeColor
            range.editable = true
            
            rangeUnderEdit = range
        }
        
        return rangeUnderEdit!
    }
    func calenderView(calendarView: GLCalendarView!, didUpdateRange range: GLCalendarDateRange!, toBeginDate beginDate: NSDate!, endDate: NSDate!) {
        updateDateRangeLabel(beginDate, endDate: endDate)
    }
    func calenderView(calendarView: GLCalendarView!, canUpdateRange range: GLCalendarDateRange!, toBeginDate beginDate: NSDate!, endDate: NSDate!) -> Bool {
        print("beginDate: \(beginDate) endDate: \(endDate)")
        print("range.beginDate: \(range.beginDate) range.endDate: \(range.endDate)")
        let today = NSDate()
        
        if beginDate.compareDateOnly(today) == .OrderedAscending {
            makeCenteredToast(outOfRangeMinToastMessage)
            return false
        }
        else if beginDate.daysFrom(endDate) > Constants.maximumDateRange {
            makeCenteredToast(outOfRangeMaxToastMessage)
            return false
        }
        return true
    }
    
    // Mark: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarSetup()
        toastSetup()
    }

    override func viewWillAppear(animated: Bool) {
        calendarView.reload()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup Functions
    
    func calendarSetup() {
        calendarView.delegate = self
        
        let calendarBeginDate = NSDate()
        let calendarEndDate = NSCalendar.currentCalendar().dateByAddingUnit(.Year, value: 1, toDate: calendarBeginDate, options: [])
        
        calendarView.firstDate = calendarBeginDate
        calendarView.lastDate = calendarEndDate

        let range = GLCalendarDateRange(beginDate: defaultStartDate, endDate: defaultEndDate)
        
        range.backgroundColor = rangeColor
        range.editable = true
        rangeUnderEdit = range
        
        calendarView.ranges = [range]
        calendarView.reload()
        
        updateDateRangeLabel(range.beginDate, endDate: range.endDate)
    }
    
    func toastSetup() {
        var style = ToastStyle()
        style.backgroundColor = UIColor.redColor()
        
        ToastManager.shared.queueEnabled = false
        ToastManager.shared.style = style
    }

    // MARK: - Helper Functions
    
    func makeCenteredToast(toastMessage: String) {
        view.makeToast(toastMessage, duration: 0.3, position: .Center, title: "Sorry", image: nil, style: ToastManager.shared.style, completion: nil)
    }
    
    func updateDateRangeLabel(beginDate: NSDate, endDate: NSDate) {
        if beginDate.compare(endDate) == .OrderedSame {
            dateRangeLabel.text = beginDate.readableDateAndMonth()
        }
        else {
            dateRangeLabel.text = beginDate.readableDateAndMonth() + " to " + endDate.readableDateAndMonth()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    }