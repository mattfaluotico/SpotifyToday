//
//  STAuth.swift
//  SpotifyToday
//
//  Created by Matthew Faluotico on 12/14/15.
//  Copyright © 2015 mf. All rights reserved.
//

import Cocoa
import OAuthSwift

class STAuth: NSObject {
    
    override init() {
        super.init();
    
        let oauthswift = OAuth2Swift(
            consumerKey:    STAuthKeys.oauthConsumerKey!,
            consumerSecret: STAuthKeys.oauthSecertKey!,
            authorizeUrl:   K.SpotifyAuthURL,
            accessTokenUrl: "https://accounts.spotify.com/api/token",
            responseType:   "code"
        );
        
        
        oauthswift.authorizeWithCallbackURL(
            
            NSURL(string: "SpotifyToday://oauth-callback/spotify")!,
            scope: "user-library-modify",
            state: generateStateWithLength(20),
            success: { credential, response, parameters in
                print(credential.oauth_token)
            },
            
            failure: { error in
                print(error.localizedDescription)
            }
        );
        
        
    }
    
    private func generateStateWithLength (len : Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomString : NSMutableString = NSMutableString(capacity: len)
        for (var i=0; i < len; i++){
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        return String(randomString);
    }
}
