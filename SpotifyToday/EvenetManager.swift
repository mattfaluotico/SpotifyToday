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

    let listener = Listener(withAppId: "SpotifyToday");
    var centerReceiver = NSDistributedNotificationCenter();
    let request = STRequest();
    var shouldUpdate = true;
    var i = 0;
    
    init() {
        
        print("creating");
        
        self.listener
            .on("save") {
                print("save");
                self.save();
            }
            .on("share") {
                print("share");
                self.share();
            }
            .on("next") {
                print("next");
                SpotifyAppleScript.progress.next();
            }
            .on("previous") {
                print("previous");
                SpotifyAppleScript.progress.previous();
            }
            .on("toggle") {
                print("toggle")
                SpotifyAppleScript.progress.toggle();
            }
            .on("update") {
                print("update");
                self.updateModel();
            }
    }
    
    func updateModel() {
        
        print("updating");
        let defaults = NSUserDefaults(suiteName: K.group)!;
        
        let state = SpotifyAppleScript.details.state();
        
        if state != "kPSS" {
            defaults.setObject(SpotifyAppleScript.details.song(), forKey: "song");
            defaults.setObject(SpotifyAppleScript.details.artist(), forKey: "artist");
            defaults.setObject(SpotifyAppleScript.details.album(), forKey: "album");
            defaults.setObject(state, forKey: "state");
            
            if state == "kPSP" {
                defaults.setBool(true, forKey: "playing");
            } else if state == "kPSp" {
                defaults.setBool(false, forKey: "playing");
            }
        }
        
        defaults.synchronize();
        
        self.listener.post("update_widget");
        
    }
    
    // strips the extra info from the track id
    private func strip(inout songId: String) {
        // strips the extra info from the track uri
        let range = songId.rangeOfString("spotify:track:");
        songId.replaceRange(range!, with: "");
    }
    
    func save() {
                
        var tid = SpotifyAppleScript.details.id();
        let song = SpotifyAppleScript.details.song();
        
        strip(&tid);
        print(tid);
        
        self.request.addSong(tid) {
            print("song added");
            self.notify("save", song: song);
        }
    }
    
    func share() {
        
        var tid = SpotifyAppleScript.details.id();
        strip(&tid);
        let shareid = K.SpotifyTrackURL(tid);
        
        let pb = NSPasteboard.generalPasteboard();
        pb.clearContents();
        pb.writeObjects([shareid]);
        
        self.notify("share", song: SpotifyAppleScript.details.song());
    }
    
    func notify(type: String, song: String) {
        let notificaiton = NSUserNotification()
        
        if (type == "save") {
            notificaiton.title = "Song Added";
            notificaiton.informativeText = "\"\(song)\" has been added to your Spotify library";
        } else {
            notificaiton.title = "Share Link Copied";
            notificaiton.informativeText = "The link to \"\(song)\" has been copied to your clipboard";
        }
        NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(notificaiton);
    }
}
