//
//  AppDelegate.swift
//  testTimelineView
//
//  Created by fancymax on 2/23/2017.
//  Copyright © 2017年 fancy. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var timelineView: FSTimelineView!

    @IBOutlet weak var clipAddTrackIndexTxt: NSTextField!
    @IBOutlet weak var clipAddTrackPosTxt: NSTextField!
    @IBOutlet weak var clipLenTxt: NSTextField!
    
    @IBAction func clickAddTrack(_ sender: AnyObject) {
        timelineView.addTrackView()
    }

    @IBAction func clickAddClip(_ sender: AnyObject) {
        let trackIndex = Int(clipAddTrackIndexTxt.stringValue)!
        let position = Double(clipAddTrackPosTxt.stringValue)!
        if clipLenTxt.stringValue == "" {
            
        }
        timelineView.addClipViewInTrack(trackIndex, offset: position)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        timelineView.addClipViewInTrack(2, offset: 20)
        timelineView.addClipViewInTrack(1, offset: 60)
        timelineView.addClipViewInTrack(4, offset: 100)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }


}

