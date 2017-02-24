//
//  FSClipView.swift
//  testTimelineView
//
//  Created by fancymax on 2/24/2017.
//  Copyright © 2017年 Wondershare. All rights reserved.
//

import Cocoa

class FSClipView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        let backGroundColor = NSColor(calibratedRed: 0, green: 1, blue: 0, alpha: 1)
        backGroundColor.set()
        NSBezierPath.fill(dirtyRect)
    }
    
    override func mouseDragged(with event: NSEvent) {
        Swift.print("mouseDragged (\(event.deltaX),\(event.deltaY))")
        //X轴任意移动
        self.frame.origin.x += event.deltaX
        //Y轴只能在轨道移动
        self.frame.origin.y -= event.deltaY
        self.needsDisplay = true
    }
    
}
