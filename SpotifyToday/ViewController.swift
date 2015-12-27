//
//  ViewController.swift
//  SpotifyToday
//
//  Created by Matthew Faluotico on 12/14/15.
//  Copyright © 2015 mf. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    let em = EvenetManager();
    @IBOutlet weak var signin: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listener = NSNotificationCenter.defaultCenter();
        listener.addObserverForName("Signin", object: nil, queue: nil) { (notification) -> Void in
            self.signedInAlready();
        }
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func viewDidAppear() {
        let defs = NSUserDefaults.standardUserDefaults();
        
        if let _ = defs.objectForKey(K.STCredKey) {
            signedInAlready();
        }
    }
    
    func signedInAlready() {
        print("already logged in");
        self.signin.enabled = false;
        self.signin.title = "You're already signed in";
    }
    
    @IBAction func signIn(sender: AnyObject) {
        STAuth.spotify();
    }
}

