//
//  AppDelegate.swift
//  SpotifyToday
//
//  Created by Matthew Faluotico on 12/14/15.
//  Copyright © 2015 mf. All rights reserved.
//

import Cocoa
import OAuthSwift

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    // When the application ends
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    // Launches with a notificaiton, checks if it's a URL
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // listen to scheme url
        NSAppleEventManager.sharedAppleEventManager().setEventHandler(self, andSelector:"handleGetURLEvent:withReplyEvent:", forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
    }
    
    // Response to the URL
    func handleGetURLEvent(event: NSAppleEventDescriptor!, withReplyEvent: NSAppleEventDescriptor!) {
        if let urlString = event.paramDescriptorForKeyword(AEKeyword(keyDirectObject))?.stringValue, url = NSURL(string: urlString) {
            applicationHandleOpenURL(url)
        }
    }
    
    class var sharedInstance: AppDelegate {
        return NSApplication.sharedApplication().delegate as! AppDelegate
    }
    
    func applicationHandleOpenURL(url: NSURL) {
        if (url.host == "oauth-callback") {
            OAuth2Swift.handleOpenURL(url)
        } else {
            // Google provider is the only one wuth your.bundle.id url schema.
            OAuth2Swift.handleOpenURL(url)
        }
    }

}

