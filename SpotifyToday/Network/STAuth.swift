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
    
    static func spotify(oauthswift: OAuth2Swift? = nil) {
        
        let auth = oauthswift ?? OAuth2Swift(
            consumerKey:    STAuthKeys.oauthConsumerKey!,
            consumerSecret: STAuthKeys.oauthSecertKey!,
            authorizeUrl:   K.SpotifyAuthURL,
            accessTokenUrl: K.SpotifyTokenURL,
            responseType:   "code"
        );
        
        
        auth.authorizeWithCallbackURL(
            
            NSURL(string: "SpotifyToday://oauth-callback/spotify")!,
            scope: "user-library-modify",
            state: generateStateWithLength(20),
            success: { credential, response, parameters in
                print(response);
                let refreshToken = parameters["refresh_token"] as! String
                self.saveCreds(client: auth.client, refreshToken: refreshToken);
                let listener = NSNotificationCenter.defaultCenter();
                listener.postNotificationName("Signin", object: nil);
            },
            failure: { error in
                print(error.localizedDescription)
            }
        );
    }
    
    static func saveCreds(client client: OAuthSwiftClient, refreshToken: String? = nil) {
        
        let keychain = NSUserDefaults.standardUserDefaults();
        keychain.setObject(client.credential.oauth_token, forKey: K.STCredKey);
        keychain.setObject(client.credential.oauth_token_secret, forKey: K.STCredSecretKey);
        keychain.setObject(NSDate(), forKey: "date");
        
        if let r = refreshToken {
            keychain.setObject(r, forKey: K.STCredRefreshToken);
        }
        
        keychain.synchronize();
    }
    
    static private func generateStateWithLength (len : Int) -> String {
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
