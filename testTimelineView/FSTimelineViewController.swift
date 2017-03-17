//
//  FSTimelineViewController.swift
//  testTimelineView
//
//  Created by fancymax on 3/14/2017.
//  Copyright © 2017年 Wondershare. All rights reserved.
//

import Cocoa

class FSTimelineViewController: NSViewController {
    @IBOutlet weak var timelineHeadListView: FSTimelineHeaderView!
    @IBOutlet weak var timelineListView: FSTimelineView!
    @IBOutlet weak var timelineHeadScrollView: SynchroScrollView!
    @IBOutlet weak var timelineScrollView: SynchroScrollView!
    @IBOutlet weak var timelinePlayheadScrollView: SynchroScrollView!
    
    var model = DemoTimeLineManager()
    
    func test() {
        let size = NSMakeSize(timelineListView.frame.size.width + 200, timelineListView.frame.size.height)
        timelineListView.setFrameSize(size)
    }
    
    override var nibName: String? {
        return "FSTimelineViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSubViews()
    }
    
    func reloadWithDemo(_ model:DemoTimeLineManager) {
        self.model = model
        //delete old clip
        self.deleteAllClip()
        //get right track count
        if model.trackCount > self.timelineListView.trackCount {
            let inc = model.trackCount - self.timelineListView.trackCount
            for _ in 1...inc {
                timelineListView.addTrackView()
                timelineHeadListView.addTrackView()
            }
        }
        else if model.trackCount < self.timelineListView.trackCount {
            let dec =  self.timelineListView.trackCount - model.trackCount
            for _ in 1...dec {
                timelineListView.removeTrackView()
                timelineHeadListView.removeTrackView()
            }
        }
        //redisplay all clip
        if model.trackCount == 0 {
            return
        }
        for x in 1...model.trackCount  {
            let track  = model.trackAtIndex(x)
            if track.clipCount == 0 {
                continue
            }
            for y in 1...track.clipCount {
                let clip = track.clipAtIndex(y)
                self.addClipInTrack(clip.level, position: clip.positionInTrack, length: clip.playDuration, with: clip)
            }
        }
    }
    
    private func setupSubViews() {
        timelineHeadScrollView.monitorDirection = .y
        timelineHeadScrollView.synchronizedScrollView = timelineScrollView
        timelineScrollView.monitorDirection = .y
        timelineScrollView.synchronizedScrollView = timelineHeadScrollView
        timelinePlayheadScrollView.monitorDirection = .x
        timelinePlayheadScrollView.synchronizedScrollView = timelineScrollView
        
        clipViews = [FSClipView]()
    }
    
    // MARK: - Public
    func pasteMediaAtPlayhead() {
        
    }
    
    // MARK:  Clip
    private func recycleClipView(_ view:FSClipView) {
        view.isFocus = false
        view.isInUse = false
        view.unbindAll()
        view.removeFromSuperview()
    }
    
    var clipViews:[FSClipView]!
    func addClipInTrack(_ trackIndex: Int, position:Int, length:Int, with model:DemoClip) {
        var view:FSClipView!
        var isFindOldView = false
        for oldView in clipViews {
            if !oldView.isInUse {
                view = oldView
                isFindOldView = true
                break
            }
        }
        
        if !isFindOldView {
            view = FSClipView()
        }
        
        view.bindAll(to: model, options: nil)
        view.isInUse = true
        timelineListView.addClipView(view,trackIndex: trackIndex, position: position, length:length)
        clipViews.append(view)
    }
    
    func cutClip() {
        
    }
    
    func copyClip() {
        
    }
    
    func deleteAllClip() {
        for view in clipViews where view.isInUse  {
            recycleClipView(view)
        }
    }
    
    func deleteFocusClip() {
        for view in clipViews where view.isFocus {
            recycleClipView(view)
        }
    }
    
    func deleteClip(at index:Int) {
        for view in clipViews where view.isInUse &&  view.trackIndex == index {
            recycleClipView(view)
        }
    }
    
    func splitAtPlayhead() {
        
    }
    
    // MARK:  Track
    func addTrack() {
        timelineListView.addTrackView()
        timelineHeadListView.addTrackView()
    }
    
    func insertTrackAbove() {
        
    }
    
    func insertTrackBelow() {
        
    }
    
    func removeTrack(at index:Int) {
        deleteClip(at: index)
        
        if index + 1 <= timelineListView.trackCount {
            for i in (index + 1)...timelineListView.trackCount {
                for view in clipViews where view.isInUse && view.trackIndex == i {
                    view.trackIndex -= 1
                }
            }
        }
        
        timelineListView.removeTrackView()
        timelineHeadListView.removeTrackView()
    }
    
    func removeAllEmptyTrack() {
        
    }
    
    func renameTrack(_ name:String) {
        
    }
    
    func turnTrackOn() {
        
    }
    
    func turnTrackOff() {
        
    }
    
    func lockTrack() {
        
    }
    
    func unlockTrack() {
        
    }
    
    func minimizeTrackHeight() {
        
    }
    
    func maximizeTrackHeight() {
        
    }
    
}
