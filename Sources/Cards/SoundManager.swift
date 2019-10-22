//
//  File.swift
//  
//
//  Created by Geoff Burns on 22/10/19.
//

import Foundation
import AVFoundation

public class SoundManager
{
    public var playlist : [String] = []
    public var _songs =  [AVAudioPlayer?] (repeating: nil, count: 7)
    public static let sharedInstance = SoundManager()
    fileprivate init() { }
    
    public func songs(_ index:Int) -> AVAudioPlayer?
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
    
}
