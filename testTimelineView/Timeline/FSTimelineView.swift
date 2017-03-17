//
//  FSTimelineView.swift
//  Timeline
//
//  Created by fancymax on 2/23/2017.
//  Copyright © 2017年 fancy. All rights reserved.
//

import Cocoa

class FSTimelineBaseView:NSView {
    
    var trackIndex = 0
    
}

class FSTimelineView: NSView {
    
    var trackCount = 0
    var trackHeight:CGFloat = 40.0
    
    var totalClipNum = 0
    
    var seekPosition:CGFloat = 0 {
        didSet {
            self.needsDisplay = true
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    func commonInit() {
        self.registerAllNotification()
    }
    
    // MARK: - Clip
    func addClipView(_ clipView:FSClipView, trackIndex: Int, position:Int, length:Int) {
        
        totalClipNum += 1
        
        let lx = self.bounds.origin.x + CGFloat(position)
        let ly = self.bounds.size.height - trackHeight * CGFloat(trackIndex)
        let lw = CGFloat(length)
        let lh = trackHeight
        
        clipView.frame = NSRect(x: lx, y: ly, width: lw, height: lh)
        clipView.trackIndex = trackIndex
        clipView.position = position
        clipView.delegate = self
        clipView.autoresizingMask = [.viewMinYMargin,.viewMaxXMargin]
        clipView.name = "clip\(totalClipNum)"
        self.addSubview(clipView)
    }
    
    // MARK: - Track
    func removeTrackView() {
        for view  in self.subviews where view is FSTrackView {
            if (view as! FSTrackView).trackIndex == trackCount {
                view.removeFromSuperview()
            }
        }
        
        trackCount -= 1
    }
    
   func addTrackView()  {
        let lx = self.bounds.origin.x
        let ly = self.bounds.size.height - trackHeight * CGFloat(trackCount + 1)
        let lw = self.bounds.size.width
        let lh = trackHeight
        let frame = NSRect(x: lx, y: ly, width: lw, height: lh)
        let view = FSTrackView(frame: frame)
        view.trackIndex = trackCount + 1
        view.autoresizingMask = [.viewMinYMargin,.viewWidthSizable]
        self.addSubview(view)
        
        if trackHeight * CGFloat(trackCount + 1) > self.bounds.height {
            let size = NSMakeSize(self.frame.size.width, trackHeight * CGFloat(trackCount + 1))
            self.frame.size = size
        }
        
        trackCount += 1
    }
    
    // MARK: - Draw
    override func draw(_ dirtyRect: NSRect) {
        let backGroundColor = NSColor(calibratedRed: 0.081841, green: 0.097876, blue: 0.110399, alpha: 1.0)
        backGroundColor.set()
        NSBezierPath.fill(dirtyRect)
        
        // Get current context
        let context = NSGraphicsContext.current()!.cgContext
        let tickHeight = self.frame.height
        let tickWidth:CGFloat = 1
        let tickColor = NSColor.white
        self.drawTick(context, pointX: seekPosition, width: tickWidth, height: tickHeight, color: tickColor)
    }
    
    private func drawTick(_ context: CGContext, pointX: CGFloat, width: CGFloat, height: CGFloat, color: NSColor) {
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(width)
        context.setLineCap(CGLineCap.round)
        context.move(to: CGPoint(x: pointX, y: 0))
        context.addLine(to: CGPoint(x: pointX, y: height))
        context.strokePath()
    }
    
    // MARK: - Notification
    func registerAllNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(FSTimelineView.recvChangeSeekPositionNotification(_:)), name: NSNotification.Name.Timeline.DidChangeSeekPosition, object: nil)
    }
    
    func recvChangeSeekPositionNotification(_ notification: Notification) {
        let seekPosition = notification.object as! CGFloat
        self.seekPosition = seekPosition
    }
}

// MARK: - FSClipViewDelegate
extension FSTimelineView: FSClipViewDelegate {
    func clipView(_ clipView: FSClipView, shouldOtherClipUnfocus shouldUnfocus: Bool) {
        if shouldUnfocus {
            for otherClipView in self.subviews where  otherClipView != clipView {
                if let clip = otherClipView as? FSClipView {
                    clip.isFocus = false
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
            if clipView.trackIndex >= trackCount {
                return false
            }
            else {
                return true
            }
        }
        return false
    }
    
    func clipView(_ clipView:FSClipView,  getYPositionBy trackIndex:Int) -> CGFloat {
        let ly = self.frame.size.height - trackHeight * CGFloat(trackIndex)
        return ly
    }
}
