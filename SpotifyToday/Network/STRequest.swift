
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
    private var keychain = NSUserDefaults.standardUserDefaults();
    private var shouldRefresh = false;
    private var counter = 0;
    
    init() {
        
        let oauthswift = OAuth2Swift(
            consumerKey:    STAuthKeys.oauthConsumerKey!,
            consumerSecret: STAuthKeys.oauthSecertKey!,
            authorizeUrl:   K.SpotifyAuthURL,
            accessTokenUrl: K.SpotifyTokenURL,
            responseType:   "code"
        );
        
        
        if let token = self.keychain.stringForKey(K.STCredKey) {
            oauthswift.client.credential.oauth_token = token;
            oauthswift.client.credential.oauth_token_secret = self.keychain.stringForKey(K.STCredSecretKey)!;
        } else {
            STAuth.spotify(oauthswift);
        }
        
        self.client = oauthswift.client;
    }
    
    func addSong(songID: String, onSuccess callback: () -> ()) {
        
        guard self.counter++ <= 1 // returns if date update doesn't work
            else {
                self.counter = 0;
                return;
            }
        
        
        var lastUpdate = self.keychain.objectForKey("date") as! NSDate;
        lastUpdate = lastUpdate.dateByAddingTimeInterval(NSTimeInterval(60 * 60));
        let now = NSDate();

        if lastUpdate.compare(now) == NSComparisonResult.OrderedAscending {
            
            self.refresh() {
                self.addSong(songID) {
                    callback();
                }
            }
            
        } else {
            
            let url = K.SpotifyAddSongURL(songID);
            let bearer = "Bearer \(self.client.credential.oauth_token)";
            
            self.client.put( url,
                parameters: [:],
                headers: ["Accept": "application/json", "Authorization": bearer],
                success: { (data, response) -> Void in
                    self.counter = 0;
                    callback()
                },
                failure: { (error) -> Void in
                    print("failure to add song");
                    print(error);
            });
        }
    }
    
    func refresh(callback: () -> () ) {

        let refreshToken = self.keychain.stringForKey(K.STCredRefreshToken);
        let params: [String: AnyObject] = ["grant_type": "refresh_token", "refresh_token" : refreshToken!];
        
        let preencode = "\(STAuthKeys.oauthConsumerKey!):\(STAuthKeys.oauthSecertKey!)";
        let utf8 = preencode.dataUsingEncoding(NSUTF8StringEncoding);
        let encoded = utf8?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0));
        
        
        let auth = "Basic \(encoded!)"
        let headers = ["Authorization": auth];
        
        self.client.post(
            K.SpotifyRefreshURL,
            parameters: params,
            headers: headers,
            success: { (data, response) -> Void in
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments);
                    let access = json["access_token"] as! String;
                    self.client.credential.oauth_token = access;
                    STAuth.saveCreds(client: self.client);
                    let lastUpdate = NSDate();
                    self.keychain.setObject(lastUpdate, forKey: "date");
                    print("token refreshed");
                    callback();
                    
                } catch {
                    print("unable to parse json response");
                }
            },
            failure: { (error) -> Void in
                print(error);
        });
    }
}
