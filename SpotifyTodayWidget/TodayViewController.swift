//
//  TodayViewController.swift
//  SpotifyTodayWidget
//
//  Created by Matthew Faluotico on 12/16/15.
//  Copyright © 2015 mf. All rights reserved.
//

import Cocoa
import NotificationCenter

class TodayViewController: NSViewController, NCWidgetProviding {

    var centerReceiver = NSDistributedNotificationCenter()
    var isPlaying = true;
    var firstShowing = true;
    var data = Dictionary<String, String>();
    
    override var nibName: String? {
        return "TodayViewController"
    }
    
    override func viewWillAppear() {
        if firstShowing {
            setUp();
        }
    }
    
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Update your data and prepare for a snapshot. Call completion handler when you are done
        // with NoData if nothing has changed or NewData if there is new data since the last
        // time we called you
        completionHandler(.NoData)
    }
    
    func setUp() {
        firstShowing = false;
        self.setListener();

        let apps = NSRunningApplication.runningApplicationsWithBundleIdentifier("mpf.SpotifyToday");
        let spotify = NSRunningApplication.runningApplicationsWithBundleIdentifier("com.spotify.client");
        
        guard !spotify.isEmpty
            else {
                self.centerReceiver.postNotificationName("SpotifyToday", object: "update", userInfo: nil);
                return;
        }
        
        guard !apps.isEmpty
            else {
               self.songLabel.stringValue = "Start SpotifyToday main app";
                return;
        }
        
        self.centerReceiver.postNotificationName("SpotifyToday", object: "update");
    }
    
    // MARK: Track info labsl
    
    @IBOutlet weak var songLabel: NSTextField!
    @IBOutlet weak var artistLabel: NSTextField!
    @IBOutlet weak var albumLabel: NSTextField!
    @IBOutlet weak var albumArtwork: NSImageView!
    
    // MARK: Buttons
    
    @IBOutlet weak var addButton: NSButton!
    
    @IBOutlet weak var playPauseButton: NSButton!
    
    // MARK: Button Actions
    
    @IBAction func shareButton(sender: AnyObject) {
        self.centerReceiver.postNotificationName("SpotifyToday", object: "share", userInfo: nil);
    }
    
    @IBAction func nextButton(sender: AnyObject) {
        self.centerReceiver.postNotificationName("SpotifyToday", object: "next", userInfo: nil);
    }

    @IBAction func playButton(sender: AnyObject) {
        self.centerReceiver.postNotificationName("SpotifyToday", object: "toggle", userInfo: nil);
    }
    
    @IBAction func previousButton(sender: AnyObject) {
        self.centerReceiver.postNotificationName("SpotifyToday", object: "previous", userInfo: nil);
    }
    
    @IBAction func addButton(sender: AnyObject) {
        self.centerReceiver.postNotificationName("SpotifyToday", object: "save", userInfo: nil);
    }
    
    func setListener() {
        
        self.centerReceiver.addObserverForName("SpotifyToday", object: nil, queue: nil) { (notification) -> Void in
            
            let x = notification.object as! String;
            
            if x == "model" {
                self.update();
            }
        }
        
        self.centerReceiver.addObserverForName("com.spotify.client.PlaybackStateChanged", object: nil, queue: nil) { (notification) -> Void in
            let x = notification.userInfo!
            let playerState = x["state"] as! String!
            
            if playerState != "stopped" {
                self.centerReceiver.postNotificationName("SpotifyToday", object: "update", userInfo: nil);
            }
            
        }
    }
    
    func togglePlay() {
        self.playPauseButton.image = isPlaying ? NSImage(named: "pause") : NSImage(named: "play");
    }
    
    func update() {
        
        let defs = NSUserDefaults(suiteName: "mpf.SpotifyToday.group")!;
        
        if let data =  defs.persistentDomainForName("mpf.SpotifyToday.group") {
            self.songLabel.stringValue = data["song"] as! String
            self.artistLabel.stringValue = data["artist"] as! String
            self.albumLabel.stringValue = data["album"] as! String
            self.isPlaying = data["playing"] as! Bool
            self.togglePlay();

        }
    }
    
}
