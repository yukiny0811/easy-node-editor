//
//  NSTouchEventView.swift
//  
//
//  Created by クワシマ・ユウキ on 2022/09/17.
//

import Cocoa

class NSTouchEventView: NSView {
    
    let idString: (nodeID: String, inputName: String)
    
    public init(frame: NSRect, idString: (String, String)) {
        self.idString = idString
        super.init(frame: frame)
        let options: NSTrackingArea.Options = [
            .mouseEnteredAndExited,
            .enabledDuringMouseDrag,
            .inVisibleRect,
            .activeInKeyWindow
        ]
        let trackingArea = NSTrackingArea(rect: frame,
                                          options: options,
                                          owner: self,
                                          userInfo: nil)
        
        self.addTrackingArea(trackingArea)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func mouseEntered(with event: NSEvent) {
        EasyNodeManager.shared.selectedInputID = self.idString
        print("entered")
    }
    
    override func mouseUp(with event: NSEvent) {
        
    }
    
    override func mouseDown(with event: NSEvent) {
        
    }
    
    override func mouseExited(with event: NSEvent) {
        EasyNodeManager.shared.selectedInputID = nil
        print("exited")
    }
    
    deinit {
        self.trackingAreas.forEach { ta in
            self.removeTrackingArea(ta)
        }
    }
}
