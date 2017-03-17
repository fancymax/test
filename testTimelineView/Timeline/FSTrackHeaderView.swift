//
//  FSTrackHeaderView.swift
//  testTimelineView
//
//  Created by fancymax on 3/14/2017.
//  Copyright © 2017年 Wondershare. All rights reserved.
//

import Cocoa

class FSTrackHeaderView: FSTimelineBaseView {
    
    var name = ""

    override func draw(_ dirtyRect: NSRect) {
        let backGroundColor = NSColor(calibratedRed: 0.171167, green: 0.215631, blue: 0.228314, alpha: 1.0)
        backGroundColor.set()
        NSBezierPath.fill(dirtyRect)
        
        drawText(name, inRect: self.bounds)
    }
    
    func drawText(_ text:String, inRect:NSRect){
        let aParagraghStyle = NSMutableParagraphStyle()
        aParagraghStyle.lineBreakMode  = .byWordWrapping
        aParagraghStyle.alignment  = .center
        
        let attrs = [NSParagraphStyleAttributeName:aParagraghStyle,NSForegroundColorAttributeName:NSColor.white] as [String : Any]
        let size = (text as NSString).size(withAttributes: attrs)
        let r:NSRect = NSMakeRect(inRect.origin.x,
                                  inRect.origin.y + (inRect.size.height - size.height)/2.0 - 2,
                                  inRect.size.width,
                                  size.height)
        (text as NSString).draw(in: r, withAttributes: attrs)
    }
    
}
