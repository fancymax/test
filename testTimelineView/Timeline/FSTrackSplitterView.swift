//
//  FSTrackSplitterView.swift
//  testTimelineView
//
//  Created by fancymax on 3/14/2017.
//  Copyright © 2017年 Wondershare. All rights reserved.
//

import Cocoa

class FSTrackSplitterView: FSTimelineBaseView {
    

    override func draw(_ dirtyRect: NSRect) {
        let backGroundColor = NSColor(calibratedRed: 0.116845, green: 0.140800, blue: 0.165792, alpha: 1.0)
        backGroundColor.set()
        NSBezierPath.fill(dirtyRect)
    }
    
}
