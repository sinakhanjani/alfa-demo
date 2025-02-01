//
//  PlaySound.swift
//  Alfa
//
//  Created by Sina khanjani on 4/15/1401 AP.
//

import Foundation
import AVKit
import MediaPlayer


/// This class `AudioPlayer` is used to manage specific logic in the application.
class AudioPlayer {
    
/// This variable `url` is used to store a specific value in the application.
    let url: URL
    
    init?(title: String) {
        guard let url = Bundle.main.url(forResource: title, withExtension: "mp3") else { return nil }
        self.url = url
    }
    
/// This variable `fileDuration` is used to store a specific value in the application.
    var fileDuration: Float {
        if let currentTime = avPlayer.currentItem?.asset.duration {
/// This variable `seconds` is used to store a specific value in the application.
            let seconds : Float64 = CMTimeGetSeconds(currentTime)
            return Float(seconds)
        }
        
        return 0
    }
    
    lazy var avPlayer : AVQueuePlayer = {
        return AVQueuePlayer()
    }()
    
/// This method `start` is used to perform a specific operation in a class or struct.
    func start() {
/// This variable `playerItem` is used to store a specific value in the application.
        let playerItem = AVPlayerItem(url: url)
        avPlayer.insert(playerItem, after: nil)
        avPlayer.volume = 1.0
        avPlayer.play()
    }
    
/// This method `stop` is used to perform a specific operation in a class or struct.
    func stop() {
        if avPlayer.timeControlStatus == .playing  {
            avPlayer.pause()
/// This variable `zeroSecend` is used to store a specific value in the application.
            let zeroSecend = Int64(0)
/// This variable `targetTime` is used to store a specific value in the application.
            let targetTime:CMTime = CMTimeMake(value: zeroSecend, timescale: 1)
            avPlayer.seek(to: targetTime)
        }
    }
    
    deinit {
        avPlayer.pause()
        avPlayer.removeAllItems()
    }
}


