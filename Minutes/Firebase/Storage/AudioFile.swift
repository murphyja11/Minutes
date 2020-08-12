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
    //@EnvironmentObject var userInfo: UserInfo
    
    private(set) var uid: String = ""
    private(set) var player: AVPlayer?
    @Published var status: AudioStatus = .undefined
    
    private var timeObserverToken: Any?
    @Published var currentTime: Double = 0.0
    @Published var duration: Double = 1.0
    private var timeScale: Int32?
    
    init() {
       do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.spokenAudio)
            //For playing volume when phone is on silent
        } catch {
            print(error.localizedDescription)
        }
    }
    
    enum AudioStatus {
        case undefined, playing, paused, completed
    }
    
    func startPlaying(uid: String, filename: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        self.uid = uid
        print("AudioFile UID: \(uid) \n\n\n\n\n\n\n")
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
            let asset = AVAsset(url: url) //, options: [AVURLAssetAllowsCellularAccessKey: false])
            //self.duration = asset.duration.seconds
            let playerItem = AVPlayerItem(asset: asset)
            NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
            self.player = AVPlayer(playerItem: playerItem)
            self.player?.actionAtItemEnd = .pause
            self.setDuration(asset: asset) { result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success( _):
                    break
                }
            }
            /*self.addTimeObserver(player: self.player) { result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success( _):
                    break
                }
            }*/
            self.play { result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success( _):
                    print("Audio File initialized and playing")
                }
            }
        }
    }
    
    private func addTimeObserver (player: AVPlayer?, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let player = player  else {
            completion(.failure(AudioFileError.playerIsNil))
            return
        }
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        print("\(NSEC_PER_SEC) \n\n\n\n")
        let time = CMTime(seconds: 0.5, preferredTimescale: timeScale)

        self.timeObserverToken = player.addPeriodicTimeObserver(forInterval: time,
                                                          queue: .main)
        { [weak self] time in
            self!.currentTime = time.seconds
            completion(.success(true))
        }
        //completion(.failure(AudioFileError.cantAddObserver))
    }
    
    private func setDuration (asset: AVAsset, completion: @escaping (Result<Bool, Error>) -> Void) {
        if asset.duration == nil {
            completion(.failure(AudioFileError.DurationIsNil))
        }
        self.duration = asset.duration.seconds
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
    
    @objc func playerDidFinishPlaying(sender: Notification) {
        if self.player == nil {
            return
        }
        //FBFirestore.updateFBUserMetrics(uid: self.userInfo.user.uid, minutes: self.duration)
        /*{ result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success( _):
                break
            }
        }*/
        print("File Finished Playing \n\n\n\n\n")
        self.status = .completed
        // This should trigger the UI to dismiss the sheet and call the end function below
    }
    
    func end () {
        if self.player == nil {
            return
        }
        //removePeriodicTimeObserver()
        //self.player!.removeTimeObserver(self.timeObserverToken)
        //self.timeObserverToken = nil

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
    
    func seek (to time: Float64) {
        let cmTime = CMTimeMakeWithSeconds(time, preferredTimescale: 48000)
        guard let _ = player else { return }
        self.player!.seek(to: cmTime)
    }
}
