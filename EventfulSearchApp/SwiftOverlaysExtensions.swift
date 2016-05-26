//
//  SwiftOverlaysExtensions.swift
//  EventfulSearchApp
//
//  Created by Miles McLeod on 2016-05-25.
//  Copyright © 2016 Miles McLeod. All rights reserved.
//

import Foundation
import SwiftOverlays

extension SwiftOverlays {
    // duration is in seconds
    class func showBlockingTextOverlayWithDuration(text: String, duration: Int) {
        self.showBlockingTextOverlay(text)
        let delay = Double(duration) * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue()) {
            SwiftOverlays.removeAllBlockingOverlays()
        }
    }
}