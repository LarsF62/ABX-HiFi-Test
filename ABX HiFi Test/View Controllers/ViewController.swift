//
//  ViewController.swift
//  ABX HiFi Test
//
//  Created by Lars Fredriksson on 2022-02-01.
//

import Cocoa

class ViewController: NSViewController
{
    let myfiles = ABXHiFiTest()
    var prefs = Preferences()
    var index_selected: Int!
    
    
    @IBOutlet weak var playXButton: NSButton!
    @IBOutlet weak var playAButton: NSButton!
    @IBOutlet weak var playBButton: NSButton!
    @IBOutlet weak var AeqXButton: NSButton!
    @IBOutlet weak var BeqXButton: NSButton!
    @IBOutlet weak var loadMusicButton: NSButton!
    //@IBOutlet weak var resultView: NSTableView!
    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPrefs()
        updateFromPrefs()
        
        playXButton.isEnabled = false
        playAButton.isEnabled = false
        playBButton.isEnabled = false
        AeqXButton.isEnabled = false
        BeqXButton.isEnabled = false
        
        tableView.delegate = self
        tableView.dataSource = self
        index_selected = -1        
    }
    

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func playXButtonClicked(_ sender: Any)
    {
        if (index_selected >= 0)
        {
            if(playXButton.title == "Pause")
            {
                playXButton.title = "Play X"
            }
            else
            {
                playXButton.title = "Pause"
            }
            playAButton.title = "Play A"
            playBButton.title = "Play B"
            myfiles.play(index: index_selected, choice: "X")
        }
    }
    
    @IBAction func playAButtonClicked(_ sender: Any) 
    {
        if (index_selected >= 0)
        {
            if(playAButton.title == "Pause")
            {
                playAButton.title = "Play A"
            }
            else
            {
                playAButton.title = "Pause"
        }
            playBButton.title = "Play B"
            playXButton.title = "Play X"
            myfiles.play(index: index_selected, choice: "A")
        }
    }

    @IBAction func playBButtonClicked(_ sender: Any)
    {
        if (index_selected >= 0)
        {
            if(playBButton.title == "Pause")
            {
                playBButton.title = "Play B"
            }
            else
            {
                playBButton.title = "Pause"
            }
            playAButton.title = "Play A"
            playXButton.title = "Play X"
            myfiles.play(index: index_selected, choice: "B")
        }
    }
    
    @IBAction func AeqXButtonClicked(_ sender: Any)
    {
        if(myfiles.a_eq_x(index: index_selected))
        {
            myfiles.music_files[index_selected].result = "Correct"
        }
        else
        {
            myfiles.music_files[index_selected].result = "Wrong"
        }
        myfiles.music_files[index_selected].x_extension = myfiles.get_x_ext(index: index_selected)
        AeqXButton.isEnabled = false
        BeqXButton.isEnabled = false
        tableView.reloadData()
    }
    @IBAction func BeqXButtonClicked(_ sender: Any)
    {
        if(myfiles.b_eq_x(index: index_selected))
        {
            myfiles.music_files[index_selected].result = "Correct"
        }
        else
        {
            myfiles.music_files[index_selected].result = "Wrong"
        }
                
        myfiles.music_files[index_selected].x_extension = myfiles.get_x_ext(index: index_selected)
        AeqXButton.isEnabled = false
        BeqXButton.isEnabled = false
        tableView.reloadData()
    }
    @IBAction func loadMusicButtonClicked(_ sender: Any) 
    {
        let dialog = NSOpenPanel();
        
                
        dialog.title                   = "Choose a wav or flac file";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = true;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = true;
        //dialog.allowedContentTypes     = ["wav","flac"]

        if (dialog.runModal() == NSApplication.ModalResponse.OK)
        {
            let result = dialog.urls // Pathname of the file
                  
            for url in result
            {
                print("adding \(url) to list")
                myfiles.add(filename: url)
                tableView.reloadData()
            } 
        }
        else
        {
            // User clicked on "Cancel"
            //print("Cancel")
            //print(Qual_select.titleOfSelectedItem ?? "NA")
            return
        }
    }
    // menus
    @IBAction func playXMenuItemSelected(_ sender: Any) {
        playXButtonClicked(sender)
    }
    @IBAction func playAMenuItemSelected(_ sender: Any) {
        playAButtonClicked(sender)
    }
    @IBAction func playBMenuItemSelected(_ sender: Any) {
        playBButtonClicked(sender)
    }
    @IBAction func AeqXMenuItemSelected(_ sender: Any) {
        AeqXButtonClicked(sender)
    }
    @IBAction func BbeqXMenuItemSelected(_ sender: Any) {
        BeqXButtonClicked(sender)
    }
    @IBAction func loadMusicFilesMenuItemSelected(_ sender: Any) {
        loadMusicButtonClicked(sender)
    }
    
    func updateStatus()
        {
            //pause if something is playing
            if(index_selected >= 0)
            {
                myfiles.pause(index: index_selected)
            }
            
            index_selected = -1
            playXButton.isEnabled = false
            playAButton.isEnabled = false
            playBButton.isEnabled = false
            AeqXButton.isEnabled = false
            BeqXButton.isEnabled = false
            //button_Stop.isEnabled = false
            
            //print("Items selected \(tableView.selectedRowIndexes.count)")
            index_selected = tableView.selectedRow
            //print("Index of selected \(String(describing: index_selected))")
            if(index_selected >= 0)
            {
                playXButton.isEnabled = true
                playAButton.isEnabled = true
                playBButton.isEnabled = true
                // check if we already got an answer
                if(!myfiles.guessed(index: index_selected))
                {
                    //print("no answer")
                    AeqXButton.isEnabled = true
                    BeqXButton.isEnabled = true
                }
                //button_Stop.isEnabled = true
            }
            else
            {
                playXButton.isEnabled = false
                playAButton.isEnabled = false
                playBButton.isEnabled = false
                AeqXButton.isEnabled = false
                BeqXButton.isEnabled = false
                //button_Stop.isEnabled = false
            }
        }
    
}

extension ViewController: NSTableViewDataSource
{
    func numberOfRows(in tableView: NSTableView) -> Int
    {
        //print("myfiels ok count \(myfiles.music_files.count)")
        return myfiles.music_files.count
    }
}

extension ViewController: NSTableViewDelegate
{

    fileprivate enum CellIdentifiers
    {
        static let NameCell = "NameCellID"
        static let ResultCell = "ResultCellID"
        static let ExtCell = "XTypeID"
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        // var image: NSImage?
        var text: String = ""
        var cellIdentifier: String = ""
    
        let item = myfiles.music_files[row]
        if(item.name != "") // check if there is content
        {
            //print("adding  line")
    
            if tableColumn == tableView.tableColumns[0]
            {
                text = item.name
                cellIdentifier = CellIdentifiers.NameCell
            }
            else if tableColumn == tableView.tableColumns[1]
            {
                text = item.result
                cellIdentifier = CellIdentifiers.ResultCell
            }
            else if tableColumn == tableView.tableColumns[2]
            {
                text = item.x_extension
                cellIdentifier = CellIdentifiers.ExtCell
            }


            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView
            {
                cell.textField?.stringValue = text
                //cell.imageView?.image = image ?? nil
                return cell
            }
        }
        return nil
    }
    
    
    override func viewWillAppear()
    {
        super.viewWillAppear()
        tableView.reloadData()
    }
    
    func tableViewSelectionDidChange(_ notification: Notification)
    {
        updateStatus() // do something
    }
}

extension ViewController
{

  // MARK: - Preferences

    func setupPrefs()
    {
        //updateDisplay(for: prefs.selectedTime)

        let notificationName = Notification.Name(rawValue: "PrefsChanged")
        NotificationCenter.default.addObserver(forName: notificationName,
                                           object: nil, queue: nil) {
            (notification) in
            self.updateFromPrefs()
        }
    }
    func updateFromPrefs()
    {
        self.myfiles.ffmpeg_prg = self.prefs.ffmpegPath
        self.myfiles.ffmpeg_qual = self.prefs.selectedQuality
        //self.resetButtonClicked(self)
    }

}
