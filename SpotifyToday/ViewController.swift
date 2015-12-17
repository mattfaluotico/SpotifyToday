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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        var button = NSButton(frame: self.view.frame);
        button.target = self;
        button.action = Selector("addSong");
        self.view.addSubview(button);
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func viewDidAppear() {
        let defs = NSUserDefaults.standardUserDefaults();
        if let _ = defs.objectForKey(K.STCredKey) {
            print("already logged in");
        } else {
            self.performSelector(Selector("login_test"), withObject: nil, afterDelay: 2);
        }
    }
    
    
    func login_test() {
        STAuth.spotify();
    }
    
    func addSong() {
        let sampleSong = "48bo7uexDvAThcRDvEB2W7";
        
        
        let req = STRequest()
        req.addSong(sampleSong);
        
    }
}

