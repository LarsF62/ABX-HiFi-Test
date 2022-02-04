//
//  AppDelegate.swift
//  ABX HiFi Test
//
//  Created by Lars Fredriksson on 2022-02-01.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    
    @IBOutlet weak var loadMusicMenuItem: NSMenuItem!
    
    @IBOutlet weak var playXMenuItem: NSMenuItem!
    
    @IBOutlet weak var playAMenuItem: NSMenuItem!
    @IBOutlet weak var playBMenuItem: NSMenuItem!
    @IBOutlet weak var AeqXMenuItem: NSMenuItem!
    @IBOutlet weak var BeqXMenuItem: NSMenuItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

