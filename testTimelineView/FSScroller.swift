//
//  FSScroller.swift
//  testTimelineView
//
//  Created by fancymax on 3/15/2017.
//  Copyright © 2017年 Wondershare. All rights reserved.
//

import Cocoa

class FSScroller: NSScroller {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        let backGroundColor = NSColor(calibratedRed: 0.105109, green: 0.129200, blue: 0.145910, alpha: 1.0)
        backGroundColor.set()
        NSBezierPath.fill(dirtyRect)
    }
    
}
