//
//  ViewController.swift
//  SpotifyToday
//
//  Created by Matthew Faluotico on 12/14/15.
//  Copyright © 2015 mf. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func viewDidAppear() {
        self.performSelector(Selector("login_test"), withObject: nil, afterDelay: 2);
    }
    
    
    func login_test() {
        var _ = STAuth();
        
    }
}

