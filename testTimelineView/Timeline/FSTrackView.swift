//
//  FSSeperateLineView.swift
//  Timeline
//
//  Created by fancymax on 2/23/2017.
//  Copyright © 2017年 fancy. All rights reserved.
//

import Cocoa

class FSTrackView: FSTimelineBaseView {
    var trackSeperatelineHeight:CGFloat = 1
    
    var isInUse = true
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    func commonInit() {
        
    }
    
    override func draw(_ dirtyRect: NSRect) {
        let backGroundColor = NSColor(calibratedWhite: 1, alpha: 0.1)
        backGroundColor.set()
        var rect = dirtyRect
        rect.size.height = trackSeperatelineHeight
        NSBezierPath.fill(rect)
    }
    

}
