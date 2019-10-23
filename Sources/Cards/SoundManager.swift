//
//  File.swift
//  
//
//  Created by Geoff Burns on 22/10/19.
//

import Foundation
import AVFoundation

public class SoundManager : NSObject, AVAudioPlayerDelegate
{
    public var playlist : [String] = []
    public var lastSounds : [String] = []
    public var _songs =  [AVAudioPlayer?] (repeating: nil, count: 7)
    fileprivate var soundQueue : [String] = []
    public var _sounds =  [String : AVAudioPlayer?] ()
    public static let sharedInstance = SoundManager()
    fileprivate override init() { super.init() }
    public var isPlaying = false
    
    func songs(_ index:Int) -> AVAudioPlayer?
    {
        let i = index % _songs.count
        
        if let song = _songs[i]
        {
            return song
        }
        let playitem = playlist[i]
        guard let url = Bundle.main.url(forResource: playitem, withExtension: "mp3") else { return nil }
        do {
              //  try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
              // try AVAudioSession.sharedInstance().setActive(true)
                
        
              //  if #available(iOS 11.0, *) {
              _songs[i] = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue )
            
              return _songs[i]
              //  } else {
              //      musicPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3.rawValue)
              //  }
         

            } catch let error {
                print(error.localizedDescription)
            }
    
        return nil
    }
    func sounds(_ key:String) -> AVAudioPlayer?
     {
       
         if let sound = _sounds[key]
         {
             return sound
         }
        
        let lower = key.lowercased()
         let lang = Locale.current.languageCode ?? "en"
         let localkey = "\(lower)-\(lang)"
         guard let url = Bundle.main.url(forResource: localkey, withExtension: "m4a") else { return nil }
         do {
          
               let sound = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.m4a.rawValue )

               sound.numberOfLoops = 0
               sound.prepareToPlay()
               sound.delegate = self
               _sounds[key] = sound
               return sound

             } catch let error {
                 print(error.localizedDescription)
             }
     
         return nil
     }

    public func playSound(_ soundName: String)
    {
        guard Game.settings.isPlayingSound else {
                stopAllSound()
                return }
      
        guard let sound = sounds(soundName) else {return}
        if isPlaying {
                  soundQueue.append(soundName)
                  return
              }
        isPlaying = true
        sound.volume = 1.0
        sound.play()
      
    }
    public func playQueuedSound(_ soundName: String) -> Bool
    {
        guard Game.settings.isPlayingSound else {
                stopAllSound()
                return true }
      
        guard let sound = sounds(soundName) else {return false}

        sound.volume = 1.0
        sound.play()
        return true
      
    }
    public func playSounds(_ soundNames: [String])
    {
        if soundNames.elementsEqual(lastSounds) { return }
        lastSounds = soundNames
        for soundName in soundNames
        {
            playSound(soundName)
        }
    }
    public func stopAllMusic(except:Int)
    {
        for (i,song) in _songs.enumerated() where song != nil && i != except
        {
            song!.stop()
        }
    }
    public func stopAllMusic()
       {
           for song in _songs where song != nil
           {
               song!.stop()
           }
       }
    public func stopAllSound()
       {
        soundQueue = []
           for (_, sound) in _sounds where sound != nil
           {
               sound!.stop()
           }
       }
    public func playMusic(_ n: Int = 0) {
          stopAllMusic(except:n)
          guard Game.settings.isPlayingMusic else {
            stopAllMusic()
            return }
          guard let song = songs(n) else { return }
          
          song.numberOfLoops = -1
          song.volume = 0.3
          if song.isPlaying {return}
          song.play()
      }
    
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        
        while true {
        guard soundQueue.count > 0 else {
            isPlaying = false
            return
            }
        let soundName = soundQueue.remove(at: 0)
        if playQueuedSound(soundName) {return }
        }
    }
        
}
