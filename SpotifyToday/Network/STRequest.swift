//
//  STRequest.swift
//  SpotifyToday
//
//  Created by Matthew Faluotico on 12/14/15.
//  Copyright © 2015 mf. All rights reserved.
//

import Cocoa
import OAuthSwift

class STRequest {
    
    private let client: OAuthSwiftClient;
    
    init(client: OAuthSwiftClient) {
        self.client = client;
    }
    
    func addSong(songID: String) {
        let url = K.SpotifyAddSongURL(songID);
                
    }
}
