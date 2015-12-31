//
//  Listener.swift
//  SpotifyToday
//
//  Created by Matthew Faluotico on 12/30/15.
//  Copyright © 2015 mf. All rights reserved.
//

import Cocoa

class Listener: NSObject {

    private var l = NSDistributedNotificationCenter();
    private var allEvent: ((NSNotification?) -> () )?;
    private let appid: String;
    
    init(withAppId appId: String) {
        self.appid = appId;
    }
    
    func post(name: String) {
        self.l.postNotificationName(appid, object: name);
    }
    
    // MARK: on
    
    func on(name: String, event: () -> () ) -> Listener {
        
        l.addObserverForName(self.appid, object: name, queue: nil) { (notification) -> Void in
            event()
        }
        
        return self;
    }
    
    func on(name: String, withNotification event: NSNotification -> Void ) -> Listener {
        
        l.addObserverForName(self.appid, object: name, queue: nil) { (notification) -> Void in
            event(notification)
        }
        
        return self;
    }
    
    // MARK: all
    
    func onAll(event: (NSNotification?) -> () ) -> Listener {
        l.addObserverForName(self.appid, object: nil, queue: nil) { (n) -> Void in
            event(n);
        }
        
        return self;
    }
}
