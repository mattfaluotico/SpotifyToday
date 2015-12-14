//
//  STAuth.swift
//  SpotifyToday
//
//  Created by Matthew Faluotico on 12/14/15.
//  Copyright © 2015 mf. All rights reserved.
//

import Cocoa
import OAuthSwift

class STAuthKeys: NSObject {
    
    private static var keyDict: NSDictionary?;
    private static let kSTKeysConsumerKey = "OAUTH_CONSUMER_KEY";
    private static let kSTKeysSecretKey = "OAUTH_SECRET_KEY";

    static var oauthConsumerKey: String? = {
        
        if keyDict == nil {
            STAuthKeys.populateKeys();
        }
        
        if let key = keyDict!.objectForKey(STAuthKeys.kSTKeysConsumerKey) {
            return (key as! String);
        } else {
            print("No consumer key found. Make sure you have a \(STAuthKeys.kSTKeysConsumerKey) populated in oauth.plist")
            return nil;
        }
    }();
    
    static var oauthSecertKey: String? = {

        if (keyDict == nil) {
            STAuthKeys.populateKeys();
        }
        
        if let key = keyDict!.objectForKey(STAuthKeys.kSTKeysSecretKey) {
            return (key as! String);
        } else {
            print("No seret key found. Make sure you have a \(STAuthKeys.kSTKeysSecretKey) populated in oauth.plist")
            return nil;
        }
    }();
    
    // reads the keys from the plist
    private static func populateKeys() {
        let filePath = NSBundle.mainBundle().pathForResource("oauth", ofType: "plist");
        self.keyDict = NSDictionary(contentsOfFile: filePath!);
    }
}
