//
//  PrefsViewController.swift
//  ABX HiFi Test
//
//  Created by Lars Fredriksson on 2022-02-01.
//

import Cocoa

class PrefsViewController: NSViewController {

    @IBOutlet weak var pathTextField: NSTextField!
    @IBOutlet weak var qualityPopup: NSPopUpButton!
    @IBOutlet weak var cancelButton: NSButton!
    @IBOutlet weak var okButton: NSButton!
    
    var prefs = Preferences()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showExistingPrefs()
    }
    
    @IBAction func popupValueChanged(_ sender: NSPopUpButton)
    {
        _ = sender.selectedItem?.title
        
    }
    
    @IBAction func pathTextFieldChanged(_ sender: Any) {
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        view.window?.close()
    }
    
    @IBAction func okButtonClicked(_ sender: Any) {
        saveNewPrefs()
        view.window?.close()
    }
    
    
    func showExistingPrefs()
    {
        // 1
        let selectedQuality = String(prefs.selectedQuality)
        let selectedPath = String(prefs.ffmpegPath)
        // 2
        qualityPopup.selectItem(withTitle: selectedQuality)

        // 3
        for item in qualityPopup.itemArray
        {
            if item.title == selectedQuality
            {
                qualityPopup.select(item)
                break
            }
        }

        // 4
        pathTextField.stringValue = selectedPath
        
    }
    
    func saveNewPrefs()
    {
        prefs.selectedQuality = qualityPopup.titleOfSelectedItem!
        prefs.ffmpegPath = pathTextField.stringValue
        NotificationCenter.default.post(name: Notification.Name(rawValue: "PrefsChanged"),
                                        object: nil)
      }
    
}
