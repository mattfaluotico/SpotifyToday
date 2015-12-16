//
//  K.swift
//  SpotifyToday
//
//  Created by Matthew Faluotico on 12/14/15.
//  Copyright © 2015 mf. All rights reserved.
//

import Cocoa

class K: NSObject {
    
    // URL for auth
    static let SpotifyAuthURL = "https://accounts.spotify.com/authorize";
    static let SpotifyTokenURL = "https://accounts.spotify.com/api/token";
    
    // URL generator for adding songs
    static func SpotifyAddSongURL(songID: String) -> String {
        return "https://api.spotify.com/v1/me/tracks?ids=\(songID)";
    }
}
