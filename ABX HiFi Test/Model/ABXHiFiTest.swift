//
//  ABXHiFiTest.swift
//  ABX HiFi Test
//
//  Created by Lars Fredriksson on 2022-02-01.
//

import Foundation
import AVFoundation

public struct mfiles
{
    var name: String
    var result: String
    var path: String
    var ext:[String] = ["",""]
    var fileurl_noext: URL
    var has_mp3: Bool
    var urla: URL
    var urlb: URL
    var urlx: URL
    var play_a:AVPlayer
    var play_b:AVPlayer
    var play_x:AVPlayer
    var ffmpeg_qual: String
    var ffmpeg_prg: String
    var x_extension: String
    
    init(fileURL: URL, cmd: String, qual: String)
    {
        let n1: Int = Int.random(in: 0 ... 1)
        var n2: Int = 1
        let org_file = fileURL.path
        
        ffmpeg_prg = cmd
        ffmpeg_qual = qual
        
        if(n1 == 1)
        {
            n2 = 0
        }
        self.name = fileURL.deletingPathExtension().lastPathComponent  // just the name of file
        self.result = "NA"
        self.path = fileURL.deletingPathExtension().path            // path to file
        self.ext[n1] = fileURL.pathExtension                        // extension of source file wav or flac
        self.ext[n2] = "mp3"
        self.fileurl_noext = fileURL.deletingPathExtension()        // url without .flac
                                         // set this when mp3 file exists
        // create url filepaths to flac and mp3 file.
        self.x_extension = ""
        // checck if mp3 exists allready
        let mp3_file = path + ".mp3"
        
        // init player
        self.urla = fileurl_noext.appendingPathExtension(ext[n1])
        self.urlb = fileurl_noext.appendingPathExtension(ext[n2])
        self.urlx = fileurl_noext.appendingPathExtension(ext[Int.random(in: 0 ... 1)])
        self.play_a = AVPlayer(url: urla)
        self.play_b = AVPlayer(url: urlb)
        self.play_x = AVPlayer(url: urlx)
        
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath:mp3_file)
        {
            has_mp3 = true
        }
        else
        {
            // create mp3
            self.has_mp3 = false
            
            if(runffmpeg(source: org_file, dest: mp3_file))
            {
                self.has_mp3 = true
            }
        }
        
        self.play_a = AVPlayer(url: urla)
        self.play_b = AVPlayer(url: urlb)
        self.play_x = AVPlayer(url: urlx)
        
    }
    
    func runffmpeg(source: String, dest:String) -> Bool
    {
        let task = Process()

        //the path to the external program you want to run
        let executableURL = URL(fileURLWithPath: ffmpeg_prg)
        task.executableURL = executableURL

        //use pipe to get the execution program's output
        let pipe = Pipe()
        task.standardOutput = pipe

        //this one helps set the directory the executable operates from
        //task.currentDirectoryURL = URL(fileURLWithPath: "/users/dan/OneDrive/Documents/")

        //all the arguments to the executable
        let args = ["-y","-i",source, "-vn", "-b:a" ,  ffmpeg_qual , dest]
        task.arguments = args

        //what to call once the process completes
        task.terminationHandler = {
            _ in
            print("process run complete.")
        }

        try! task.run()
        task.waitUntilExit()

        //all this code helps you capture the output so you can, for e.g., show the user
        let d = pipe.fileHandleForReading.readDataToEndOfFile()
        let ds = String (data: d, encoding: String.Encoding.utf8)
        print("terminal output: \(ds!)")

        print("execution complete...")
        if(task.terminationStatus == 0)
        {
            return true
        }
        return false
    }
    
}

class ABXHiFiTest
{
    var music_files = [mfiles]()  // array with files
    private var ext:[String] = ["",""]
    var ffmpeg_qual: String = "128k"
    var ffmpeg_prg: String = "/usr/bin/ffmpeg"
    
    init()
    {
        // Get user defaults
        //let defaults = UserDefaults.standard
        //ffmpeg_qual = defaults.string(forKey: "Qual") ?? "192k"
        /*do {
            ffmpeg_path = try Shell("/usr/bin/which",arguments:ffmpeg_prg)
            
        }
        catch {
            print("\(error)") //handle or silence the error here
        }*/
    }
    
    init(filename: URL)
    {
        // Get user defaults
        //let defaults = UserDefaults.standard
        //ffmpeg_qual = defaults.string(forKey: "Qual") ?? "192k"
        music_files.append(mfiles(fileURL: filename, cmd: ffmpeg_prg, qual: ffmpeg_qual))
        
    }
    
    func print_name()
    {
        for item in music_files
        {
            print(item.name)
            print(item.ext[0])
            print(item.path)
            print(item.has_mp3)
            print(item.fileurl_noext)
            print(item.urla)
        }
    }
    
    func add(filename: URL)
    {
        music_files.append(mfiles(fileURL: filename, cmd: ffmpeg_prg, qual: ffmpeg_qual))
        print_name()
    }
    
    func play(index: Int, choice: String)
    {
        switch choice
        {
            case "A":
                //print_name()
                if (music_files[index].play_b.rate != 0 && music_files[index].play_b.error == nil)
                {
                    music_files[index].play_b.pause()
                }
                if (music_files[index].play_x.rate != 0 && music_files[index].play_x.error == nil)
                {
                    music_files[index].play_x.pause()
                }
                if (music_files[index].play_a.rate != 0 && music_files[index].play_a.error == nil)
                {
                    music_files[index].play_a.pause()
                }
                else
                {
                    music_files[index].play_a.play()
                }
                //print("playing A")
            case "B":
                
                if (music_files[index].play_a.rate != 0 && music_files[index].play_a.error == nil)
                {
                    music_files[index].play_a.pause()
                }
                if (music_files[index].play_x.rate != 0 && music_files[index].play_x.error == nil)
                {
                    music_files[index].play_x.pause()
                }
                if (music_files[index].play_b.rate != 0 && music_files[index].play_b.error == nil)
                {
                    music_files[index].play_b.pause()
                }
                else
                {
                    music_files[index].play_b.play()
                }
                //print("playing B")
            case "X":
                
                if (music_files[index].play_a.rate != 0 && music_files[index].play_a.error == nil)
                {
                    music_files[index].play_a.pause()
                }
                if (music_files[index].play_b.rate != 0 && music_files[index].play_b.error == nil)
                {
                    music_files[index].play_b.pause()
                }
                if (music_files[index].play_x.rate != 0 && music_files[index].play_x.error == nil)
                {
                    music_files[index].play_x.pause()
                }
                else
                {
                    music_files[index].play_x.play()
                }
                //print("playing X")
            default:
                print("error")
        }
        
        //print("Playing \(music_files[index].name)")
    }
    
    // stopp alla
    func stop(index: Int)
    {
        music_files[index].play_a.pause()
        music_files[index].play_a.seek(to: CMTime.zero)
        
        music_files[index].play_b.pause()
        music_files[index].play_b.seek(to: CMTime.zero)
        
        music_files[index].play_x.pause()
        music_files[index].play_x.seek(to: CMTime.zero)
    }
    
    func pause(index: Int)
    {
        music_files[index].play_a.pause()
        
        music_files[index].play_b.pause()
        
        music_files[index].play_x.pause()
        
    }
    
    func guessed(index: Int) -> Bool
    {
        if(music_files[index].result == "NA")
        {
            return false
        }
        return true
    }
    
    func a_eq_x(index: Int) -> Bool
    {
        if(music_files[index].urla == music_files[index].urlx)
        {
            return true
        }
        return false
    }
    func b_eq_x(index: Int) -> Bool
    {
        if(music_files[index].urlb == music_files[index].urlx)
        {
            return true
        }
        return false
    }
    
    func get_x_ext(index: Int) -> String
    {
        //print(music_files[index].urlx.pathExtension)
        return music_files[index].urlx.pathExtension
    }
}
