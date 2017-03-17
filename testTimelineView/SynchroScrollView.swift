//
//  SynchroScrollView.swift
//  testTimelineView
//
//  Created by fancymax on 3/15/2017.
//  Copyright © 2017年 Wondershare. All rights reserved.
//

import Cocoa

enum monitorDirection {
    case x
    case y
}

class SynchroScrollView: NSScrollView {
    var monitorDirection:monitorDirection = .y
    
    weak var synchronizedScrollView: NSScrollView? {
        willSet {
            stopSynchronizing()
        }
        didSet {
            if let contentView = synchronizedScrollView?.contentView {
                contentView.postsBoundsChangedNotifications = true
                NotificationCenter.default.addObserver(self, selector: #selector(SynchroScrollView.synchronizedViewContentBoundsDidChange(_:)), name: .NSViewBoundsDidChange, object: contentView)
            }
        }
    }
    
    func stopSynchronizing() {
        if let scrollview = self.synchronizedScrollView {
            let contentView = scrollview.contentView
            NotificationCenter.default.removeObserver(self, name: .NSViewBoundsDidChange, object: contentView)
        }
    }
    
    func synchronizedViewContentBoundsDidChange(_ notification:Notification) {
        let changedContentView = notification.object as! NSClipView
        // get the origin of the NSClipView of the scroll view that
        // we're watching
        let changedBoundsOrigin = changedContentView.documentVisibleRect.origin
        
        // get our current origin
        let curOffset = self.contentView.bounds.origin
        var newOffset = curOffset
        
        // scrolling is synchronized in the vertical plane
        // so only modify the y component of the offset
        if monitorDirection == .x {
            newOffset.x = changedBoundsOrigin.x
        }
        else {
            newOffset.y = changedBoundsOrigin.y
        }
        
        // if our synced position is different from our current
        // position, reposition our content view
        if !NSEqualPoints(curOffset, changedBoundsOrigin){
            // note that a scroll view watching this one will
            // get notified here
            self.contentView.scroll(to: newOffset)
            // we have to tell the NSScrollView to update its
            // scrollers
            self.reflectScrolledClipView(self.contentView)
        }
    }
}
