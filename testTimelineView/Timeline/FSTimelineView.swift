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
    
    func getClipFrameBy(_ trackIndex:Int,xOffset:CGFloat) ->NSRect {
        let lx = self.frame.origin.x + xOffset
        let ly = self.frame.size.height - trackHeight * CGFloat(trackIndex)
        let lw = self.clipWidth
        let lh = self.clipHeight
        let frame = NSRect(x: lx, y: ly, width: lw, height: lh)
        return frame
    }
    
    func addClipViewInTrack(_ trackIndex: Int, offset:Double) {
        
        let frame = self.getClipFrameBy(trackIndex, xOffset: CGFloat(offset))
        
        let clipView = FSClipView(frame: frame)
        clipView.trackIndex = trackIndex
        clipView.position = offset
        clipView.delegate = self
        clipView.autoresizingMask = [.viewMinYMargin,.viewMaxXMargin]
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
    
    func clipView(_ clipView: FSClipView, getXPositionBy newFrame: NSRect) -> CGFloat {
        
        let cgRect = NSRectToCGRect(newFrame)
        for clip in self.subviews where clip is FSClipView && clip != clipView {
            let otherCGRect = NSRectToCGRect(clip.frame)
            
            if cgRect.intersects(otherCGRect) {
                if cgRect.origin.x < otherCGRect.origin.x {
                    return (otherCGRect.origin.x - cgRect.size.width)
                }
                else {
                    return (otherCGRect.origin.x +  otherCGRect.size.width)
                    
                }
            }
        }

        return newFrame.origin.x
    }
    
    func clipView(_ clipView: FSClipView, shouldChangeTrackBy yOffset: CGFloat) -> Bool {
        
        if yOffset > trackHeight {
            if clipView.trackIndex <= 1 {
                return false
            }
            else {
                return true
            }
        }
        if yOffset < -trackHeight {
            return true
        }
        return false
    }
    
    func clipView(_ clipView:FSClipView,  getYPositionBy trackIndex:Int) -> CGFloat {
        let ly = self.frame.size.height - trackHeight * CGFloat(trackIndex)
        return ly
    }
}
