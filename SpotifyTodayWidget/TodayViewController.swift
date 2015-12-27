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
    
    override var nibName: String? {
        return "TodayViewController"
    }
    
    override func viewDidAppear() {
        common();
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Update your data and prepare for a snapshot. Call completion handler when you are done
        // with NoData if nothing has changed or NewData if there is new data since the last
        // time we called you
        completionHandler(.NoData)
    }
    
    
    func common() {
        
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
        self.centerReceiver.postNotificationName("SpotifyToday", object: "add", userInfo: nil);
    }
    
    
    func togglePlay() {
        self.playPauseButton.image = isPlaying ? NSImage(named: "pause") : NSImage(named: "play");
    }
    
    func update() {
        let defaults = NSUserDefaults(suiteName: "mpf.SpotifyToday.widget");
        if let data = defaults {
            self.songLabel.stringValue = data.stringForKey("song") ?? "song";
            self.artistLabel.stringValue = data.stringForKey("artist") ?? "artst";
            self.albumLabel.stringValue = data.stringForKey("album") ?? "album";
        }
    }
    
}
