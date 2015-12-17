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

    
    @IBOutlet weak var button: NSButton!
    
    override func viewDidAppear() {
        self.button.target = self;
        self.button.action = Selector("test");
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Update your data and prepare for a snapshot. Call completion handler when you are done
        // with NoData if nothing has changed or NewData if there is new data since the last
        // time we called you
        completionHandler(.NoData)
    }

    func test() {
        let notify = NSNotification(name: "SpotifyToday", object: "test")
        centerReceiver.postNotification(notify)
    }
}
