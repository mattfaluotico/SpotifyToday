//
//  EvenetManager.swift
//  SpotifyToday
//
//  Created by Matthew Faluotico on 12/16/15.
//  Copyright © 2015 mf. All rights reserved.
//

import Cocoa
import NotificationCenter

class EvenetManager {

    let listener = NSDistributedNotificationCenter()
    var data = Dictionary<String, String>();
    let request: STRequest;
    var shouldUpdate = true;
    
    init() {
        
        self.request = STRequest();
        
        listener.addObserverForName("SpotifyToday", object: nil, queue: nil) { (notification) -> Void in
            
            self.shouldUpdate = false;
            
            let cmd = notification.object as! String
        
            switch(cmd) {
            case "save" : self.save(); break;
            case "next": SpotifyAppleScript.progress.next();
            case "previous": SpotifyAppleScript.progress.previous();
            case "toggle" : SpotifyAppleScript.progress.toggle();
            case "update" : self.shouldUpdate = true;
            default: self.updateModel();
            }
            
        };
        
        listener.addObserverForName("com.spotify.client.PlaybackStateChanged", object: nil, queue: nil) { (notification) -> Void in
            
            let info = notification.userInfo!
            let state = info["Player State"]! as! String
            let controller = NCWidgetController.widgetController()
            
            if state == "Stopped" {
                controller.setHasContent(false, forWidgetWithBundleIdentifier: K.bundleWidget)
            } else{
                controller.setHasContent(true, forWidgetWithBundleIdentifier: K.bundleWidget)
            }
            
            
            self.updateModel();
        }
    }
    
    func updateModel() {
        
        print("updating data");
        
        self.data["state"] = SpotifyAppleScript.details.state();
        
        if !self.shouldUpdate {
            self.listener.postNotificationName("SpotifyToday", object: "update", userInfo: nil);
        }
        
        if self.data["state"] != "kPSS" {
            self.data["song"] = SpotifyAppleScript.details.song();
            self.data["artist"] = SpotifyAppleScript.details.artist();
            self.data["album"] = SpotifyAppleScript.details.album();
        }
        
        print(self.data.description);
        
        let defaults = NSUserDefaults(suiteName: K.bundleWidget)!;
        defaults.setPersistentDomain(self.data, forName: K.bundleWidget);
        defaults.synchronize();
    }
    
    func save() {
        let tid = SpotifyAppleScript.details.id();

        self.request.addSong(tid) { () -> () in
            print("song added");
        }
    }
}
