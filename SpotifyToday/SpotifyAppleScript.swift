//
//  STAppleScriptSpotify.swift
//  SpotifyToday
//
//  Created by Matthew Faluotico on 12/16/15.
//  Copyright © 2015 mf. All rights reserved.
//

import Cocoa

class SpotifyAppleScript {
    
    class progress {
        
        var cat = "cadrds";
        
        static func next() {
            SpotifyAppleScript.script("next track");
        }
        
        static func previous() {
            SpotifyAppleScript.script("next track");
        }
        
        static func toggle() {
            SpotifyAppleScript.script("playpause");
        }
    }
    
    class details {
        static func album() -> String {
            return SpotifyAppleScript.script("album of current track");
        }
        
        static func artist() -> String {
            return SpotifyAppleScript.script("artist of current track");
        }
        
        static func song() -> String {
            return SpotifyAppleScript.script("name of current track");
        }
        
        static func id() -> String {
            return SpotifyAppleScript.script("id of current track");
        }
        
        static func state() -> String {
            return SpotifyAppleScript.script("player state");
        }
    }
    
    private static func script(text: String) -> String {
        let script = NSAppleScript(source: "tell application \"Spotify\" to \(text)" )
        var err: NSDictionary?
        let result = script?.executeAndReturnError(&err);
        return (result?.stringValue != nil) ? result!.stringValue! : "";
    }
    
}
