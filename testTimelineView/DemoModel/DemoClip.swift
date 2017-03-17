//
//  DemoClip.swift
//  testTimelineView
//
//  Created by fancymax on 3/15/2017.
//  Copyright © 2017年 Wondershare. All rights reserved.
//

import Cocoa

class DemoClip: NSObject {
    var name = ""
    var trimStartTime:Int = 0
    var trimEndTime:Int = 0
    
    var renderRegion:NSRect = NSZeroRect
    
    var level:Int = 0  {
        didSet {
//            print("DemoClip level = \(level)")
        }
    }
    
    var positionInTrack:Int = 0 {
        didSet {
//            print("DemoClip positionInTrack = \(positionInTrack)")
        }
    }
    
    var playDuration:Int = 0
    let resourceDuration:Int = 0
    
    deinit {
        print("DemoClip deinit")
    }
    
    override var description: String {
        return "\(name) level:\(level) position:\(positionInTrack) duration:\(playDuration)"
    }
}

