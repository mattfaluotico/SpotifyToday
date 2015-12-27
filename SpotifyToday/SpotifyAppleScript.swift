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
        
        static func getCover() -> NSData {
            
            print("geting cover");
            
            var result: NSData?
            var id = SpotifyAppleScript.details.id();
            let localOrNot = id.substringToIndex(id.startIndex.advancedBy(14))
            
            if( localOrNot != "spotify:local:" ){
                id = id.substringFromIndex(id.startIndex.advancedBy(14)) //ignore 'spotify:track'
                let request = NSMutableURLRequest(URL: NSURL(string: "https://api.spotify.com/v1/tracks/\(id)")!)
                let session = NSURLSession.sharedSession()
                request.HTTPMethod = "GET"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let task1 = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                    if(error == nil && data != nil){
                        var imageurl: String?
                        let jsonvalue: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves)
                        
                        if(jsonvalue != nil ){
                            let jsondict = jsonvalue as! NSDictionary
                            let albumvalue = jsondict.valueForKey("album")
                            
                            if(albumvalue != nil ){
                                let imagesdict = albumvalue!.valueForKey("images") as! NSArray
                                let imageinfo = imagesdict[2] as! NSDictionary
                                imageurl = imageinfo.valueForKey("url") as? String
                            }
                        }
                        
                        if(imageurl != nil){
                            
                            let request2 = NSMutableURLRequest(URL: NSURL(string: imageurl!)!)
                            let session2 = NSURLSession.sharedSession()
                            request2.HTTPMethod = "GET"
                            request2.addValue("image/jpeg", forHTTPHeaderField: "Content-Type")
                            
                            let task2 = session2.dataTaskWithRequest(request2, completionHandler: {data2, response2, error2 -> Void in
                                if(data2 != nil){
                                    result = data2!
                                }else{
                                    result = NSData()
                                }
                            })
                            task2.resume()
                            
                        }
                        
                    }else{
                        result = NSData()
                    }
                })
                
                task1.resume()
                
                while(result == nil){
                    usleep(100)
                }
            } else{
                result = NSData()
            }
            return result!
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
