//
//  FSTimelineView.swift
//  testCALayer
//
//  Created by fancymax on 2/23/2017.
//  Copyright © 2017年 fancy. All rights reserved.
//

import Cocoa

class FSTimelineView: NSView {
    
    var trackCount = 0
    var trackHeight:CGFloat = 40.0
    var trackSeperatelineHeight:CGFloat = 1
    
    var clipWidth:CGFloat = 50.0
    var clipHeight:CGFloat = 40.0

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        let backGroundColor = NSColor(calibratedWhite: 0, alpha: 0.8)
        backGroundColor.set()
        NSBezierPath.fill(dirtyRect)
    }
    
    func addTrackView()  {
        
        let lx = self.frame.origin.x
        let ly = self.frame.size.height - trackHeight * CGFloat(trackCount)
        let lw = self.frame.size.width
        let lh = trackSeperatelineHeight
        let frame = NSRect(x: lx, y: ly, width: lw, height: lh)
        
        let trackView = FSTrackView(frame: frame)
        self.addSubview(trackView)
        
        //Add layout
        
        
        trackCount += 1
    }
    
    func addClipViewIn(_ trackIndex: Int, offset:Double) {
        
        let lx = self.frame.origin.x + CGFloat(offset)
        let ly = self.frame.size.height - trackHeight * CGFloat(trackIndex)
        let lw = self.clipWidth
        let lh = self.clipHeight
        let frame = NSRect(x: lx, y: ly, width: lw, height: lh)
        
        let clipView = FSClipView(frame: frame)
        self.addSubview(clipView)
    }
    
}
