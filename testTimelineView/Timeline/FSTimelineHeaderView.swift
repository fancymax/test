//
//  FSTimelineHeaderView.swift
//  testTimelineView
//
//  Created by fancymax on 3/14/2017.
//  Copyright © 2017年 Wondershare. All rights reserved.
//

import Cocoa

class FSTimelineHeaderView: NSView {
    
    var trackCount = 0
    var trackHeight:CGFloat = 40.0
    var trackSeperatelineHeight:CGFloat = 1

    override func draw(_ dirtyRect: NSRect) {
        let backGroundColor = NSColor(calibratedRed: 0.163793, green: 0.191806, blue: 0.216826, alpha: 1.0)
        backGroundColor.set()
        NSBezierPath.fill(dirtyRect)
    }
    
    func addTrackView()  {
        
        var lx = self.bounds.origin.x
        var ly = self.bounds.size.height - trackHeight * CGFloat(trackCount + 1)
        var lw = self.bounds.size.width
        var lh = trackHeight - trackSeperatelineHeight
        var frame = NSRect(x: lx, y: ly, width: lw, height: lh)
        let trackHeaderView = FSTrackHeaderView(frame: frame)
        trackHeaderView.trackIndex = trackCount + 1
        trackHeaderView.name = "Track\(trackCount + 1)"
        trackHeaderView.autoresizingMask = [.viewMinYMargin]
        self.addSubview(trackHeaderView)
        
        lx = self.bounds.origin.x
        ly = self.bounds.size.height - trackHeight * CGFloat(trackCount + 1)
        lw = self.bounds.size.width
        lh = trackSeperatelineHeight
        frame = NSRect(x: lx, y: ly, width: lw, height: lh)
        let splitterView = FSTrackSplitterView(frame: frame)
        splitterView.trackIndex = trackCount + 1
        splitterView.autoresizingMask = [.viewMinYMargin]
        self.addSubview(splitterView)
        
        if trackHeight * CGFloat(trackCount + 1) > self.bounds.height {
            let size = NSMakeSize(self.frame.size.width, trackHeight * CGFloat(trackCount + 1))
            self.frame.size = size
        }
        
        trackCount += 1
    }
    
    func removeTrackView() {
        for view  in self.subviews where (view as! FSTimelineBaseView).trackIndex == trackCount {
            view.removeFromSuperview()
        }
        
        trackCount -= 1
    }
    
}
