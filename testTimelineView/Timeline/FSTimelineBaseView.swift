//
//  FSTimelineBaseView.swift
//  testTimelineView
//
//  Created by fancymax on 3/17/2017.
//  Copyright © 2017年 Wondershare. All rights reserved.
//

import Cocoa

class FSTimelineBaseViewTest:NSView {
    
    var trackIndex = 0
    
    // MARK: - Binding
    var bindKeys:[String]? {
        return nil
    }
    
    var bindInfo:[String:Any]!
    
    func bindAll(to model: Any, options: [String : Any]? = nil) {
        if bindKeys == nil {
            return
        }
        for key in bindKeys! {
            let viewKey = key
            let modelKey = key
            self.bind(viewKey, to: model, withKeyPath: modelKey, options:options)
        }
    }
    
    func unbindAll() {
        if bindKeys == nil {
            return
        }
        for key in bindKeys! {
            self.unbind(key)
        }
    }
    
    override func bind(_ binding: String, to observable: Any, withKeyPath keyPath: String, options: [String : Any]? = nil) {
        
        (observable as! NSObject).addObserver(self, forKeyPath: keyPath, options: [.initial,.new], context: nil)
        let bindingsData = [NSObservedObjectKey:observable,NSObservedKeyPathKey:keyPath,NSOptionsKey:options]
        bindInfo[binding] = bindingsData
    }
    
    override func unbind(_ binding: String) {
        let observedObject = self.infoForBinding(binding)?[NSObservedObjectKey]
        let observedKeyPath = binding
        if observedObject == nil {
            return
        }
        (observedObject as! NSObject).removeObserver(self, forKeyPath: observedKeyPath)
        bindInfo.removeValue(forKey: observedKeyPath)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let key = keyPath {
            Swift.print("key = \(key)")
            let newValue = (object as! NSObject).value(forKey: key)
            
            self.setValue(newValue, forKey: key)
        }
    }
    
    override func infoForBinding(_ binding: String) -> [String : Any]? {
        var info = bindInfo[binding]
        if info == nil  {
            info = super.infoForBinding(binding)
        }
        return info as! [String : Any]?
    }
    
    func updateObservedObject(for keyPath:String,value: Any) {
        if let observedObjectForTrackIndex = self.infoForBinding(keyPath)?[NSObservedObjectKey] {
            (observedObjectForTrackIndex as! NSObject).setValue(value, forKey: keyPath)
        }
    }
}
