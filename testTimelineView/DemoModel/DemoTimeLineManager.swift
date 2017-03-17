//
//  DemoTimeLineManager.swift
//  testTimelineView
//
//  Created by fancymax on 3/16/2017.
//  Copyright © 2017年 Wondershare. All rights reserved.
//

import Cocoa

class DemoTimeLineManager: NSObject {
    var trackGroup = [DemoTrack]()

    private var maxLevel = 1
    
    var trackCount:Int  {
        return trackGroup.count
    }
    
    func trackAtIndex(_ index:Int) -> DemoTrack {
        return trackGroup[index - 1]
    }
    
    func createNewTrack() -> DemoTrack {
        return DemoTrack()
    }
    
//    - (BOOL)addTrack:(FSTimeLineTrack *)track ;
//    - (BOOL)insertTrack:(FSTimeLineTrack *)track atIndex:(int)nIndex  ;
//    - (BOOL)deleteTrack:(FSTimeLineTrack *)track ;
    
    func addTrack(_ track: DemoTrack) {
        track.level = maxLevel
        trackGroup.append(track)
        maxLevel += 1
    }
    
    func insertTrack(_ track: DemoTrack, at index:Int) {
        let curTrack = trackGroup[index - 1]
        track.level = curTrack.level
        trackGroup.insert(track, at: index - 1)
        
        for i in index...trackGroup.count - 1 {
            trackGroup[i].level += 1
        }
    }
    
    func deleteTrack(_ track: DemoTrack)  {
        
    }
    
//    - (BOOL)addClip:(FSTimeLineBaseClip *)clip toTrack:(FSTimeLineTrack *)track atPoistion:(int)nStartPos;
//    - (BOOL)moveClip:(FSTimeLineBaseClip *)clip toTrack:(FSTimeLineTrack *)track atPoistion:(int)nStartPos;//处理跨轨道拖拽
//    - (BOOL)deleteClip:(FSTimeLineBaseClip *)clip toTrack:(FSTimeLineTrack *)track;
    
    func addClip(_ clip:DemoClip, to track:DemoTrack, at position:Int) {
        track.addClip(clip, at: position)
    }
    
    func moveClip(_ clip:DemoClip, to track:DemoTrack, at position:Int) {
        
    }
    
    func deleteClip(_ clip:DemoClip, to track:DemoTrack) {
        track.deleteClip(clip)
    }
    
//    - (BOOL)spliteClip:(FSTimeLineBaseClip *)clip atTrack:(FSTimeLineTrack *)track spliteAtTrackPosition:(int)nPos;
    
    func spilitClip(_ clip:DemoClip, at track: DemoTrack,spliteAtTrackPosition pos:Int) {
        
    }
    
}

//extension DemoTimeLineManager:CustomDebugStringConvertible {
//    override var description: String {
//        var res = ""
//        
//        return res
//        
//    }
//}
