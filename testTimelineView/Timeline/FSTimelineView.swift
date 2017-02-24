//
//  FSTimelineView.swift
//  Timeline
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
    
    func addClipViewInTrack(_ trackIndex: Int, offset:Double) {
        
        let lx = self.frame.origin.x + CGFloat(offset)
        let ly = self.frame.size.height - trackHeight * CGFloat(trackIndex)
        let lw = self.clipWidth
        let lh = self.clipHeight
        let frame = NSRect(x: lx, y: ly, width: lw, height: lh)
        
        let clipView = FSClipView(frame: frame)
        clipView.trackIndex = trackIndex
        clipView.position = offset
        clipView.delegate = self
        self.addSubview(clipView)
    }
}

extension FSTimelineView: FSClipViewDelegate {
    func clipView(_ clipView: FSClipView, shouldOtherClipUnfocus shouldUnfocus: Bool) {
        if shouldUnfocus {
            for otherClipView in self.subviews where  otherClipView != clipView {
                if let clip = otherClipView as? FSClipView {
                    if clip.isFocus {
                        clip.isFocus = false
                    }
                }
            }
        }
    }
    
    func clipView(_ clipView: FSClipView, shouldChangeTrackByOffset yOffset: CGFloat) -> Bool {
        
        if yOffset > trackHeight {
            if clipView.trackIndex <= 1 {
                return false
            }
            
            clipView.trackIndex -= 1
            let ly = self.frame.size.height - trackHeight * CGFloat(clipView.trackIndex)
            clipView.frame.origin.y = ly
            return true
        }
        
        if yOffset < -trackHeight {
            clipView.trackIndex += 1
            let ly = self.frame.size.height - trackHeight * CGFloat(clipView.trackIndex)
            clipView.frame.origin.y = ly
            return true
        }
        
        return false
    }
}
