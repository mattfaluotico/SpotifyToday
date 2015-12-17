//
//  EvenetManager.swift
//  SpotifyToday
//
//  Created by Matthew Faluotico on 12/16/15.
//  Copyright © 2015 mf. All rights reserved.
//

import Cocoa

class EvenetManager {

    var centerReceiver = NSDistributedNotificationCenter()
    
    init() {
        centerReceiver.addObserverForName("SpotifyToday", object: nil, queue: nil) { (note) -> Void in
            
            let cmd = note.object as! String
            
            switch(cmd) {
            case "next": SpotifyAppleScript.progress.next();
            case "previous": SpotifyAppleScript.progress.previous();
            case "toggle" : SpotifyAppleScript.progress.toggle();
            default: self.updateModel();
            }
            
            self.updateModel();
        };
    }
    
    func updateModel() {
        
    }
    
    func test_event() {
        
        
        print("im pringing");
    }
}
