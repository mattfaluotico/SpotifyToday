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
    private var allEvent: (() -> () )?;
    private let appid: String;
    
    init(withAppId appId: String) {
        self.appid = appId;
    }
    
    func post(name: String) {
        self.l.postNotificationName(appid, object: name);
    }
    
    // MARK: on
    
    func on(name: String, event: () -> () ) -> Listener {

        self.on(name, eventWithNotification: {(note) -> () in
            event();
        });
        
        return self;
    }
    
    func on(name: String, eventWithNotification: (NSNotification) -> () ) -> Listener {
        
        l.addObserverForName(self.appid, object: name, queue: nil) { (n) -> Void in
            eventWithNotification(n);
        }
        
        return self;
    }
    
    // MARK: all
    
    func all() {
        self.allEvent!();
    }
    
    func onAll(event: () -> () ) -> Listener {
        
        self.allEvent = event;
        
        l.addObserverForName(self.appid, object: nil, queue: nil) { (n) -> Void in
            self.allEvent!()
        }
        
        return self;
    }
    
    func onAll(eventWithNotification event: (NSNotification) -> () ) -> Listener {
        l.addObserverForName(self.appid, object: nil, queue: nil) { (n) -> Void in
            event(n);
        }
        
        return self;
    }
    
}
