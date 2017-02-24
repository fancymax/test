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
    func clipView(_ clipView:FSClipView,shouldChangeTrackByOffset yOffset:CGFloat) -> Bool
//    func clipView(_ clipView:FSClipView,shouldrePositionBy yOffset:CGFloat) -> Bool
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
    
    private var accumulationY:CGFloat = 0
    private var lastlx:CGFloat = 0
    private var lastly:CGFloat = 0

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
    
    override func mouseDragged(with event: NSEvent) {
        
        self.frame.origin.x += event.deltaX
        
        accumulationY -= event.deltaY
        if let delegate = self.delegate {
            if delegate.clipView(self, shouldChangeTrackByOffset: accumulationY) {
                accumulationY = 0
            }
        }

        self.needsDisplay = true
    }
    
    override func mouseDown(with event: NSEvent) {
        lastlx = self.frame.origin.x
        lastly = self.frame.origin.y
        
        if !isFocus {
            isFocus = true
            if let delegate = self.delegate {
                delegate.clipView(self, shouldOtherClipUnfocus: true)
            }
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        accumulationY = 0
    }
    
}
