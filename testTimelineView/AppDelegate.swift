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
    @IBOutlet weak var testView: NSView!
    
    @IBOutlet weak var testBox: NSBox!
    @IBOutlet weak var clipAddTrackIndexTxt: NSTextField!
    @IBOutlet weak var clipAddTrackPosTxt: NSTextField!
    @IBOutlet weak var clipLenTxt: NSTextField!
    
    @IBOutlet weak var trackIndexTxt: NSTextField!
    var timelineViewController = FSTimelineViewController()
    
    @IBAction func clickAddTrack(_ sender: AnyObject) {
        timelineViewController.addTrack()
    }

    @IBAction func clickAddClip(_ sender: AnyObject) {
        var trackIndex:Int = 1
        var position: Int = 1
        var length:Int = 50
            
        if let value = Int(clipAddTrackIndexTxt.stringValue) {
           trackIndex = value
        }
        if let value = Int(clipAddTrackPosTxt.stringValue) {
            position = value
        }
        if let value = Int(clipLenTxt.stringValue) {
            length = value
        }
        timelineViewController.addClipInTrack(trackIndex, position: position,length:length, with:DemoClip())
    }
    
    @IBAction func clickDeleteClip(_ sender:AnyObject?) {
        timelineViewController.deleteFocusClip()
    }
    
    @IBAction func clickRemoveTrack(_ sender: AnyObject) {
        var trackIndex:Int = 1
        if let value = Int(trackIndexTxt.stringValue) {
            trackIndex = value
        }
        timelineViewController.removeTrack(at: trackIndex)
    }
    
    var demoModel = DemoTimeLineManager()
    func createDemo() {
        let track1 = demoModel.createNewTrack()
        demoModel.addTrack(track1)
        let clip2 = DemoClip()
        clip2.playDuration = 100
        clip2.name = "clip2"
        demoModel.addClip(clip2, to: track1, at: 200)
        let clip3 = DemoClip()
        clip3.playDuration = 200
        clip3.name = "clip3"
        demoModel.addClip(clip3, to: track1, at: 300)
        
        let track2 = demoModel.createNewTrack()
        demoModel.addTrack(track2)
        let clip1 = DemoClip()
        clip1.name = "clip1"
        clip1.playDuration = 300
        demoModel.addClip(clip1, to: track2, at: 100)
        
        let track3 = demoModel.createNewTrack()
        demoModel.insertTrack(track3, at: 1)
    }
    
    @IBAction func printDemoModel (_ sender:AnyObject?) {
        for track in demoModel.trackGroup {
            print(track)
            for clip in track.clipGroup {
                print(clip)
            }
        }
    }
    
    @IBAction func test(_ sender: AnyObject) {
        timelineViewController.test()
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        testBox.contentView = timelineViewController.view
        
        createDemo()
        
        timelineViewController.reloadWithDemo(demoModel)
    }

}

