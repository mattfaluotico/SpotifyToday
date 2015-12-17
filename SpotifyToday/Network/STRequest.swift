
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
    
    init() {
        
        let keychain = NSUserDefaults.standardUserDefaults();
        
        let oauthswift = OAuth2Swift(
            consumerKey:    STAuthKeys.oauthConsumerKey!,
            consumerSecret: STAuthKeys.oauthSecertKey!,
            authorizeUrl:   K.SpotifyAuthURL,
            accessTokenUrl: K.SpotifyTokenURL,
            responseType:   "code"
        );
        
        if let token = keychain.stringForKey(K.STCredKey) {
            oauthswift.client.credential.oauth_token = token;
            oauthswift.client.credential.oauth_token_secret = keychain.stringForKey(K.STCredSecretKey)!;
        } else {
            STAuth.spotify(oauthswift);
        }
        
        self.client = oauthswift.client;
    }
    
    func addSong(songID: String, onSuccess callback: () -> ()) {
    
        let url = K.SpotifyAddSongURL(songID);
        
        let bearer = "Bearer \(self.client.credential.oauth_token)";
        
        do {
            
        }
        self.client.put(url,
            parameters: [:],
            headers: ["Accept": "application/json", "Authorization": bearer],
            success: { (data, response) -> Void in
                callback()
            }) { (error) -> Void in
                print("failure to add song");
                print(error);
        }
                
    }
}
