//
//  AudioFile.swift
//  FirebaseFrontend
//
//  Created by Jack Murphy on 8/4/20.
//  Copyright © 2020 Jack Murphy. All rights reserved.
//

import Foundation
import FirebaseStorage
import AVFoundation

class AudioFile: ObservableObject {
    var player: AVPlayer?
    @Published var status: AudioStatus = .undefined
    
    let timeObserver: PlayerTimeObserver
    @Published var currentTime: TimeInterval = 0
    var duration: Double = 0.0
    
    init() {
       do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.spokenAudio)
            //For playing volume when phone is on silent
        } catch {
            print(error.localizedDescription)
        }
    }
    
    enum AudioStatus {
        case undefined, playing, paused
    }
    
    func startPlaying(filename: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let audioRef  = Storage.storage().reference().child(filename)
        audioRef.downloadURL { url, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let url = url else {
                completion(.failure(AudioFileError.urlIsNil))
                return
            }
            let playerItem = AVPlayerItem(url: url)
            self.duration = playerItem.duration.seconds
            self.player = AVPlayer(playerItem: playerItem)
            //self.addPeriodicTimeObserver(player: self.player)
            self.playImmediately { result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success( _):
                    print("Audio File initialized and playing")
                }
            }
            /*self.play { result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success( _):
                    print("Audio File initialized and playing")
                }
            }*/
        }
    }
    
    private func playImmediately(completion: @escaping (Result<Bool, AudioFileError>) -> Void) {
        if self.player == nil {
            completion(.failure(AudioFileError.playerIsNil))
            return
        }
        self.player!.playImmediately(atRate: 1.0)
        self.status = .playing
        completion(.success(true))
    }
    
    func play(completion: @escaping (Result<Bool, AudioFileError>) -> Void) {
        if self.player == nil {
            completion(.failure(AudioFileError.playerIsNil))
            return
        }
        self.player!.play()
        self.status = .playing
        completion(.success(true))
    }
    
    func pause(completion: @escaping (Result<Bool, AudioFileError>) -> Void) {
        if self.player == nil {
            completion(.failure(AudioFileError.playerIsNil))
            return
        }
        self.status = .paused
        self.player!.pause()
        completion(.success(true))
    }
    
    func end () {
        if self.player == nil {
            return
        }
        //removePeriodicTimeObserver()
        self.player = nil
        self.status = .undefined
    }
    
    func rewind (_ seconds: Float64) {
        let currentTime = player!.currentTime()
        var newTime = currentTime.seconds - seconds
        if newTime <= 0 {
            newTime = 0
        }
        player!.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
        
    }
    
    func fastForward (_ seconds: Float64) {
        let currentTime = player!.currentTime()
        var newTime = CMTimeGetSeconds(currentTime) + seconds
        if newTime >= self.duration {
            newTime = self.duration
        }
        player!.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
    
    }
}

import Combine

class PlayerTimeObserver {
    @EnvironmentObject var audioFile: AudioFile
    
    let publisher = PassthroughSubject<TimeInterval, Never>()
    private weak var player: AVPlayer?
    var timeObserverToken: Any?
    private var paused = false    
    
    init() {
        self.player = audioFile.player
        let time = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        timeObserverToken = player!.addPeriodicTimeObserver(forInterval: time,
                                                           queue: .main) { [weak self] time in
            guard let self = self else { return }
            self.publisher.send(time.seconds)
        }
    }
    
    deinit {
        if let timeObserverToken = timeObserverToken {
            self.player!.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
}
