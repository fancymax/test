//
//  FSClipView.swift
//  Timeline
//
//  Created by fancymax on 2/24/2017.
//  Copyright © 2017年 Wondershare. All rights reserved.
//

import Cocoa

protocol FSClipViewDelegate: class {
    func clipView(_ clipView:FSClipView,shouldOtherClipUnfocus shouldUnfocus:Bool)
    func clipView(_ clipView:FSClipView,getXPositionBy newFrame: NSRect) -> CGFloat
    func clipView(_ clipView:FSClipView,shouldChangeTrackBy yOffset: CGFloat) -> Bool
    func clipView(_ clipView:FSClipView,getYPositionBy trackIndex:Int) -> CGFloat
}

enum ClipDragOperation:Int {
    case none
    case drag
    case trimStart
    case trimEnd
}

class FSClipView: NSView {
    
    weak var delegate:FSClipViewDelegate?
    
    var dragOperation:ClipDragOperation = .none
    
    private var _isFocus = false
    var isFocus:Bool  {
        get {
            return _isFocus
        }
        set {
            if newValue != _isFocus {
                _isFocus = newValue
                self.needsDisplay = true
            }
        }
    }
    
    var isInUse:Bool = true
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    private func commonInit() {
        bindInfo = [String:Any]()
        addTrimViewTrackingAreas()
    }
    
    // MARK: - View Property
    private var _trackIndex:Int = 0
    var trackIndex: Int  {
        get {
            return _trackIndex
        }
        set {
            if newValue != _trackIndex {
                _trackIndex = newValue
                if delegate == nil {
                    return
                }
                var newOrigin = self.frame.origin
                newOrigin.y = delegate!.clipView(self, getYPositionBy: _trackIndex)
                setFrameOrigin(newOrigin)
            }
        }
    }
    
    var position:Int = 0
    
    // MARK: - Binding Property
    // View's Property Name must be same with Model's Property Name
    var name:String = ""
    
    //在第几个轨道,从1开始
    @objc private var level :Int = 0 {
        didSet {
            if oldValue != level {
                updateObservedObject(for: #keyPath(FSClipView.level),value: level)
            }
        }
    }
    
    //在轨道的位置
    @objc private var positionInTrack:Int = 0 {
        didSet {
            if oldValue !=  positionInTrack {
                updateObservedObject(for: #keyPath(FSClipView.positionInTrack),value: positionInTrack)
            }
        }
    }
    
    var resourceDuration:Int = 0
    
    // MARK: - Binding
    let bindKeys = [#keyPath(FSClipView.level),
                           #keyPath(FSClipView.positionInTrack)]
    
    private var bindInfo:[String:Any]!
    
    func bindAll(to model: Any, options: [String : Any]? = nil) {
        for key in bindKeys {
            let viewKey = key
            let modelKey = key
            self.bind(viewKey, to: model, withKeyPath: modelKey, options:options)
        }
    }
    
    func unbindAll() {
        for key in bindKeys {
            self.unbind(key)
        }
    }
    
    override func bind(_ binding: String, to observable: Any, withKeyPath keyPath: String, options: [String : Any]? = nil) {
        
        (observable as! NSObject).addObserver(self, forKeyPath: keyPath, options: .new, context: nil)
        let bindingsData = [NSObservedObjectKey:observable,NSObservedKeyPathKey:keyPath,NSOptionsKey:options]
        bindInfo[binding] = bindingsData
    }
    
    override func unbind(_ binding: String) {
        let observedObject = self.infoForBinding(binding)?[NSObservedObjectKey]
        let observedKeyPath = binding
        (observedObject as! NSObject).removeObserver(self, forKeyPath: observedKeyPath)
        bindInfo.removeValue(forKey: observedKeyPath)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let key = keyPath {
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
    
    private func updateObservedObject(for keyPath:String,value: Any) {
        if let observedObjectForTrackIndex = self.infoForBinding(keyPath)?[NSObservedObjectKey] {
            (observedObjectForTrackIndex as! NSObject).setValue(value, forKey: keyPath)
        }
    }
    
    // MARK: - Trim
    private var _trackingStartArea:NSTrackingArea?
    private var _trackingEndArea:NSTrackingArea?
    private let _trackingStartRect:NSRect = NSMakeRect(0.1, 0, 10, 100)
    private var _trackingEndRect:NSRect = NSMakeRect(0.1, 0, 10, 100)
    
    private func addTrimViewTrackingAreas() {
        _trackingEndRect = NSMakeRect(NSWidth(self.frame) - 10, 0, 10, 100)
        
        _trackingStartArea = NSTrackingArea(rect: _trackingStartRect, options:[NSTrackingAreaOptions.activeAlways, NSTrackingAreaOptions.cursorUpdate,NSTrackingAreaOptions.mouseEnteredAndExited,NSTrackingAreaOptions.mouseMoved], owner: self, userInfo: nil)
        self.addTrackingArea(_trackingStartArea!)
        
        _trackingEndArea = NSTrackingArea(rect: _trackingEndRect , options:[NSTrackingAreaOptions.activeAlways, NSTrackingAreaOptions.cursorUpdate,NSTrackingAreaOptions.mouseEnteredAndExited,NSTrackingAreaOptions.mouseMoved], owner: self, userInfo: nil)
        self.addTrackingArea(_trackingEndArea!)
    }
    
    
    override func updateTrackingAreas() {
        self.removeTrackingArea(_trackingStartArea!)
        self.removeTrackingArea(_trackingEndArea!)
        
        self.addTrimViewTrackingAreas()
    }
    
    override func resetCursorRects() {
        self.addCursorRect(_trackingStartRect, cursor:  NSCursor.resizeRight())
        self.addCursorRect(_trackingEndRect, cursor: NSCursor.resizeLeft())
    }
    
    // MARK: - Mouse
    override func mouseDown(with event: NSEvent) {
        self.isFocus = true
        if let delegate = self.delegate {
            delegate.clipView(self, shouldOtherClipUnfocus: true)
        }
        
        let pt = self.convert(event.locationInWindow, from: nil)
        if NSPointInRect(pt, _trackingStartRect) {
            dragOperation = .trimStart
        }else if NSPointInRect(pt, _trackingEndRect) {
            dragOperation = .trimEnd
        }else {
            dragOperation = .drag
        }
        
        switch dragOperation {
        case .drag:
            self.trackForDrag()
        case .trimStart,.trimEnd:
            self.trackForTrim(dragOperation)
        default:
            self.trackForDrag()
        }
    }
    
    private func trackForTrim(_ trimType:ClipDragOperation) {

        let startOrigin = self.frame.origin
        let originSize = self.frame.size
        
        var xTotalMoved:CGFloat = 0
        
        self.window!.trackEvents(matching: [.leftMouseDragged, .leftMouseUp], timeout:NSEventDurationForever, mode: .defaultRunLoopMode) { event, stop in
            
            xTotalMoved += event.deltaX
            
            if trimType == .trimStart {
                let newPoint = NSMakePoint(startOrigin.x + xTotalMoved, startOrigin.y)
                self.setFrameOrigin(newPoint)
                self.setFrameSize(NSMakeSize(originSize.width - xTotalMoved, originSize.height))
            }
            else if trimType == .trimEnd {
                self.setFrameSize(NSMakeSize(originSize.width + xTotalMoved, originSize.height))
            }
            
            if event.type == .leftMouseUp {
                stop.pointee = true
            }
        }
    }
    
    
    private func trackForDrag() {
        var startOrigin = self.frame.origin
        var xTotalMoved:CGFloat = 0
        var yTotalMoved:CGFloat = 0
        
        self.window!.trackEvents(matching: [.leftMouseDragged, .leftMouseUp], timeout:NSEventDurationForever, mode: .defaultRunLoopMode) { event, stop in
            
            xTotalMoved += event.deltaX
            yTotalMoved -= event.deltaY
            
            if let delegate = self.delegate {
                if delegate.clipView(self, shouldChangeTrackBy: yTotalMoved) {
                    if yTotalMoved > 0 {
                        self._trackIndex -= 1
                    }
                    else {
                        self._trackIndex += 1
                    }
                    
                    startOrigin.y = delegate.clipView(self, getYPositionBy: self._trackIndex)
                    yTotalMoved = 0
                }
                else {
                    var newOrigin = NSPoint(x: startOrigin.x + xTotalMoved, y: startOrigin.y)
                    let newFrame = NSMakeRect(newOrigin.x, newOrigin.y, self.frame.width, self.frame.height)
                    newOrigin.x = delegate.clipView(self, getXPositionBy: newFrame)
                    if newOrigin.x < 0 {
                        newOrigin.x = 0
                    }
                    self.setFrameOrigin(newOrigin)
                }
            }
            
            if event.type == .leftMouseUp {
                self.position = Int(self.frame.origin.x)
                self.positionInTrack = self.position
                stop.pointee = true
            }
        }
    }
    
    
    // MARK: - Draw
    override func draw(_ dirtyRect: NSRect) {
        NSColor(calibratedWhite: 1, alpha: 0.8).set()
        NSBezierPath.fill(dirtyRect)
        
        drawText(name, inRect: self.bounds)
        
        if isFocus {
            let path = NSBezierPath(rect: self.bounds)
            path.lineWidth = 3
            NSColor.yellow.set()
            path.stroke()
        }
    }
    
    func drawText(_ text:String, inRect:NSRect){
        let aParagraghStyle = NSMutableParagraphStyle()
        aParagraghStyle.lineBreakMode  = .byWordWrapping
        aParagraghStyle.alignment  = .center
        
        let attrs = [NSParagraphStyleAttributeName:aParagraghStyle] as [String : Any]
        let size = (text as NSString).size(withAttributes: attrs)
        let r:NSRect = NSMakeRect(inRect.origin.x,
                                  inRect.origin.y + (inRect.size.height - size.height)/2.0 - 2,
                                  inRect.size.width,
                                  size.height)
        (text as NSString).draw(in: r, withAttributes: attrs)
    }
    
}
