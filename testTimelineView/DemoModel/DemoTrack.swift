//
//  DemoTrack.swift
//  testTimelineView
//
//  Created by fancymax on 3/16/2017.
//  Copyright © 2017年 Wondershare. All rights reserved.
//

import Cocoa

class DemoTrack: NSObject {
    var clipGroup = [DemoClip]()
    
    var level:Int = 0 {
        didSet {
            for clip in clipGroup {
                clip.level = level
            }
        }
    }
    
    
//    - (NSUInteger)clipCount ;
//    - (FSTimeLineBaseClip *)clipAtIndex:(int)index ;
//    
//    - (BOOL)addClip:(FSTimeLineBaseClip *)clip atPoistion:(int)nStartPos isSupportUndo:(BOOL)isSupport;
//    - (BOOL)moveClip:(FSTimeLineBaseClip *)clip atPoistion:(int)nStartPos isSupportUndo:(BOOL)isSupport;;
//    - (BOOL)deleteClip:(FSTimeLineBaseClip *)clip isSupportUndo:(BOOL)isSupport;
//    - (BOOL)removeAllClipsAndSupportUndo:(BOOL)isSupport;
    
    var clipCount:Int {
        return clipGroup.count
    }
    
    func clipAtIndex(_ index:Int) -> DemoClip {
        return clipGroup[index - 1]
    }
    
    func addClip(_ clip:DemoClip, at position:Int) {
        clip.level = self.level
        clip.positionInTrack = position
        
        clipGroup.append(clip)
    }
    
    func moveClip(_ clip:DemoClip, at position:Int) {
        
    }
    
    func deleteClip(_ clip:DemoClip) {
        var index = 0
        for i in 0...clipGroup.count - 1 {
            if clipGroup[i] == clip {
                index = i
                break
            }
        }
        clipGroup.remove(at: index)
    }
    
    func removeAllClip() {
        
    }
    
    override var debugDescription: String {
        return "track\(level)"
    }
    
    override var description: String {
        return "track level:\(level)"
    }

}
