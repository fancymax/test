//
//  FSClipView.swift
//  Timeline
//
//  Created by fancymax on 2/24/2017.
//  Copyright © 2017年 Wondershare. All rights reserved.
//

import Cocoa

protocol FSClipViewDelegate: class {
    func clipView(_ clipView:FSClipView,shouldOtherClipUnfocus shouldUnfocus:Bool)
    func clipView(_ clipView:FSClipView,getXPositionBy newFrame: NSRect) -> CGFloat
    func clipView(_ clipView:FSClipView,shouldChangeTrackBy yOffset: CGFloat) -> Bool
    func clipView(_ clipView:FSClipView,getYPositionBy trackIndex:Int) -> CGFloat
}

class FSClipView: NSView {
    
    weak var delegate:FSClipViewDelegate?
    var isFocus:Bool = false {
        didSet {
            self.needsDisplay = true
        }
    }
    var trackIndex:Int = 0 
 
    var position:Double = 0
    
    override func draw(_ dirtyRect: NSRect) {
        NSColor(calibratedWhite: 1, alpha: 0.8).set()
        NSBezierPath.fill(dirtyRect)
        
        if isFocus {
            let path = NSBezierPath(rect: self.bounds)
            path.lineWidth = 3
            NSColor.yellow.set()
            path.stroke()
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        
        if !isFocus {
            isFocus = true
            if let delegate = self.delegate {
                delegate.clipView(self, shouldOtherClipUnfocus: true)
            }
        }
        
        var startingOrigin = self.frame.origin
        var xTotalMoved:CGFloat = 0
        var yTotalMoved:CGFloat = 0
        
        self.window!.trackEvents(matching: [.leftMouseDragged, .leftMouseUp], timeout:NSEventDurationForever, mode: .defaultRunLoopMode) { event, stop in
            
            xTotalMoved += event.deltaX
            yTotalMoved -= event.deltaY
            
            if let delegate = self.delegate {
                if delegate.clipView(self, shouldChangeTrackBy: yTotalMoved) {
                    if yTotalMoved > 0 {
                        self.trackIndex -= 1
                    }
                    else {
                        self.trackIndex += 1
                    }
                    startingOrigin.y = delegate.clipView(self, getYPositionBy: self.trackIndex)
                    yTotalMoved = 0
                }
                else {
                    var newOrigin = NSPoint(x: startingOrigin.x + xTotalMoved, y: startingOrigin.y)
                    let newFrame = NSMakeRect(newOrigin.x, newOrigin.y, self.frame.width, self.frame.height)
                    newOrigin.x = delegate.clipView(self, getXPositionBy: newFrame)
                    self.setFrameOrigin(newOrigin)
                }
            }
            
            if event.type == .leftMouseUp {
                stop.pointee = true
            }
        }
    }
    
    
}
