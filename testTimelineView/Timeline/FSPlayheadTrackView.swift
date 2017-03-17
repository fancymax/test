//
//  FSPlayheadTrackView.swift
//  testTimelineView
//
//  Created by fancymax on 3/14/2017.
//  Copyright © 2017年 Wondershare. All rights reserved.
//

import Cocoa

class TimeRuler: NSObject {
    var zoom:Int = 1
    
    func pixel2Frame(_ pixel:Int) -> Int {
        return 0
    }
    
    func frame2pixel(_ frame:Int) -> Int {
        return 0
    }
}

class FSPlayheadTrackView: NSView {
    
    let frameRate = 30
    var totalFrames = 100
    
    var tickColor = NSColor(calibratedRed: 0.159394, green: 0.203865, blue: 0.216547, alpha: 1.0)
    
    // MARK: - Initializers
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private let headImage = NSImage(named: "head")!
    
    private var headPositionX:CGFloat = 0 {
        didSet {
            NotificationCenter.default.post(name: Notification.Name.Timeline.DidChangeSeekPosition, object:headPositionX)
            self.needsDisplay = true
        }
    }
    
    private func getStrFromTick(_ tick:Int) -> String {
        let second = tick / frameRate
        let frameTick = tick % frameRate
        
        return String(format: "0:00:%0.2d;%0.2d", second,frameTick)
    }
    
    // MARK: - Draw
    override func draw(_ dirtyRect: NSRect) {
        
        // Colors
        let color = NSColor(calibratedRed: 0.120894, green: 0.140786, blue: 0.165758, alpha: 1.0)
        
        // Get current context
        let context = NSGraphicsContext.current()!.cgContext
        
        // Rectangle Drawing
        let rectanglePath = NSBezierPath(rect: NSMakeRect(0, 0, self.frame.width, self.frame.height))
        color.setFill()
        rectanglePath.fill()
        
        
        let ticks = totalFrames
        let space:CGFloat = 20
        
        var tickHeight:CGFloat = 0
        var tickWidth:CGFloat = 0
        
        for i in 0...ticks {
            let pointX:CGFloat = CGFloat(i) * space
            if i % 5 == 0 {
                tickHeight = self.frame.height * 0.3
                tickWidth = 2
            } else {
                tickHeight = self.frame.height * 0.2
                tickWidth = 1
            }
            
            self.drawTick(context, pointX: pointX, width: tickWidth, height: tickHeight, color: tickColor)
            
            if i % 10 == 0 {
                let textRect = NSMakeRect(pointX, 20, 55, 5)
                let text = getStrFromTick(i)
                drawText(text, inRect: textRect)
            }
        }
        
        let pt = NSMakePoint(headPositionX - headImage.size.width/2, self.bounds.size.height - headImage.size.height)
        headImage.draw(at: pt, from: NSZeroRect, operation: .sourceOver, fraction: 1.0)
        
        drawPlayheadTick(context, pointX: headPositionX)
    }
    
    private func drawPlayheadTick(_ context: CGContext, pointX: CGFloat){
        let height = self.bounds.size.height - headImage.size.height
        let width:CGFloat = 1
        self.drawTick(context, pointX: headPositionX, width: width, height: height, color: NSColor.white)
    }
    
    private func drawTick(_ context: CGContext, pointX: CGFloat, width: CGFloat, height: CGFloat, color: NSColor) {
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(width)
        context.setLineCap(CGLineCap.round)
        context.move(to: CGPoint(x: pointX, y: 0))
        context.addLine(to: CGPoint(x: pointX, y: height))
        context.strokePath()
    }
    
    private func drawText(_ text:String, inRect:NSRect){
        let aParagraghStyle = NSMutableParagraphStyle()
        aParagraghStyle.lineBreakMode  = .byWordWrapping
        aParagraghStyle.alignment  = .center
        
        let attrs = [NSParagraphStyleAttributeName:aParagraghStyle,NSForegroundColorAttributeName:NSColor(calibratedRed: 0.438033, green: 0.478465, blue: 0.486962, alpha: 1.0)] as [String : Any]
        let size = (text as NSString).size(withAttributes: attrs)
        let r:NSRect = NSMakeRect(inRect.origin.x,
                                  inRect.origin.y + (inRect.size.height - size.height)/2.0 - 2,
                                  size.width,
                                  size.height)
        (text as NSString).draw(in: r, withAttributes: attrs)
    }
    
    // MARK: - Mouse Event
    override func mouseDown(with event: NSEvent) {
        var mouseDownPoint = self.convert(event.locationInWindow, from: nil)
        headPositionX = mouseDownPoint.x
        
        self.window!.trackEvents(matching: [.leftMouseDragged, .leftMouseUp], timeout:NSEventDurationForever, mode: .defaultRunLoopMode) { event, stop in
            
            mouseDownPoint = self.convert(event.locationInWindow, from: nil)
            self.headPositionX = mouseDownPoint.x
            
            if event.type == .leftMouseUp {
                stop.pointee = true
            }
        }
    }
    
}
