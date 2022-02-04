//
//  Preferences.swift
//  ABX HiFi Test
//
//  Created by Lars Fredriksson on 2022-02-04.
//

import Foundation

struct Preferences
{
    var selectedQuality: String
    {
        get
        {
            let savedQuality = UserDefaults.standard.string(forKey: "selectedQuality")
            if savedQuality != nil
            {
                return savedQuality!
            }
         return "192K"
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: "selectedQuality")
        }
    }
    
    var ffmpegPath: String
    {
        get
        {
            let savedPath = UserDefaults.standard.string(forKey: "ffmpegPath")
            if savedPath != nil
            {
                return savedPath!
            }
         return "/usr/local/bin/ffmpeg"
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: "ffmpegPath")
        }
    }
}
