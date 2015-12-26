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
    
    override var nibName: String? {
        return "TodayViewController"
    }
    
    override func viewDidAppear() {

    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Update your data and prepare for a snapshot. Call completion handler when you are done
        // with NoData if nothing has changed or NewData if there is new data since the last
        // time we called you
        completionHandler(.NoData)
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
    }
    
    @IBAction func nextButton(sender: AnyObject) {
    }

    @IBAction func playButton(sender: AnyObject) {
    }
    
    @IBAction func previousButton(sender: AnyObject) {
    }
    
    @IBAction func addButton(sender: AnyObject) {
    }
    
}
