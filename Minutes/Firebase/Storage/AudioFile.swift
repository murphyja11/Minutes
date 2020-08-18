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
    
    private(set) var metadata: FBAudioMetadata?
    private var playerItemContext = 0
    private(set) var player: AVPlayer?
    
    enum AudioStatus {
        case undefined, playing, paused, stalled, completed, error
    }
    
    @Published var status: AudioStatus = .undefined
    
    
    var healthCheckTimer: Timer?
    
    private var timeObserverToken: Any?
    @Published var currentTime: Double = 0.0
    //@Published var timeBuffered: Double = 0.0
    @Published var duration: Double = 180.0
    private var timeScale: Int32?
    
    var hasForcedDurationLoad: Bool = false
    
    // MARK: - Audio Event Bools
    var didPause: Bool = false
    var didStall: Bool = false
    var didRewind: Bool = false
    var didFastForward: Bool = false
    var didSeek: Bool = false
    
    
    
    init() {
       do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.spokenAudio)
            //For playing volume when phone is on silent
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Start Playing
    // sets uid property, downloads file, creates asset, playerItem, and player
    // Gets audio duration from asset, sets End Time and Stalling Notification for playerItem, Time Observer for player
    // Finally, it starts playing the audio
    
    func startPlaying(metadata: FBAudioMetadata, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        self.metadata = metadata
        // create reference to audio file in Firebase Cloud Storage
        let audioRef  = Storage.storage().reference().child(metadata.filename)
        
        // being downloading URL.  I believe this should allow streaming the data
        audioRef.downloadURL { url, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            // check if url is nil
            guard let url = url else {
                completion(.failure(AudioFileError.urlIsNil))
                return
            }
            // automatically load playable asset key
            let assetKeys = ["playable", "duration"]
            
            // initialize static asset object
            // https://developer.apple.com/documentation/avfoundation/avasset
            let asset = AVAsset(url: url)
            
            // initialize the playerItem. A dynamic object that stores info about the asset,
            // https://developer.apple.com/documentation/avfoundation/avplayeritem
            let playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: assetKeys)
            
            /*playerItem.addObserver(self,
                                   forKeyPath: #keyPath(AVPlayerItem.status),
                                   options: [.old, .new],
                                   context: &playerItemContext)*/
            
            
            // Initialize the player.  Through this you can manage the playback and timing of the media asset
            // https://developer.apple.com/documentation/avfoundation/avplayer
            self.player = AVPlayer(playerItem: playerItem)
            
            // add endTime and Stalling observers to playerItem
            self.addPlayerItemObservers()
            // pause the player at the end.  This is redundant
            self.player?.preventsDisplaySleepDuringVideoPlayback = true
            self.player?.actionAtItemEnd = .pause
            
            // Access the duration of the asset and set it as a property. Throws if asset is nil
            try? self.setDuration(asset: asset)
            // Observe the current time of the player.  Throws if player is nil
            try? self.addTimeObserver()
            
            // try playing the audio file.  Throws if player is nil
            do {
                try self.play()
                completion(.success(true))
            } catch {
                self.status = .error
                completion(.failure(AudioFileError.UnableToPlay))
            }
        }
    }
    
    
    // MARK: - Adding Observers to Player Item and Player, getting duration of Asset
    
    private func addPlayerItemObservers () {
        let nc = NotificationCenter.default
        nc.addObserver(self,
                       selector: #selector(playerItemDidPlayToEndTime),
                       name: .AVPlayerItemDidPlayToEndTime,
                       object: self.player!.currentItem)
        nc.addObserver(self,
                       selector: #selector(playerItemDidStall),
                       name: .AVPlayerItemPlaybackStalled,
                       object: self.player!.currentItem)
    }
    
    private func addTimeObserver () throws {
        guard let _ = self.player else {
            throw AudioFileError.playerIsNil
        }
        self.timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.5, preferredTimescale: self.timeScale!)

        self.timeObserverToken = self.player!.addPeriodicTimeObserver(forInterval: time,
                                                          queue: .main) // TODO: - Should this be the main thread????
        { [weak self] time in
            self!.currentTime = time.seconds
        }
    }
    
    private func timeBuffered () -> Double {
        guard let _ = self.player else { return 0.0 }
        guard let _ = self.player!.currentItem else { return 0.0 }
        let timeRange = self.player!.currentItem!.loadedTimeRanges.last?.timeRangeValue
        guard let _ = timeRange else { return 0.0 }
        return CMTimeGetSeconds(timeRange!.end) //CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration)
    }
    
    private func setDuration (asset: AVAsset?) throws {
        guard let asset = asset else {
            throw AudioFileError.AssetIsNil
        }
        if asset.duration == nil {
            throw AudioFileError.DurationIsNil
        }
        self.duration = asset.duration.seconds
    }
    
    
    // MARK: Configure PlayerItem endTime and Stalling Notifications
    
    @objc func playerItemDidPlayToEndTime(sender: Notification) {
        if self.player == nil {
            return
        }
        print("File Finished Playing")
        self.status = .completed
        // This will trigger the UI to dismiss the sheet and call the AudioFile.end() function below
    }
    
    @objc func playerItemDidStall(sender: Notification) {
        self.didStall = true
        self.status = .stalled
        // Something about setting a self.delegate to streamplayerdidstall?
    }
    
    private func removeObserver () {
        if let token = self.timeObserverToken {
            if let _ = self.player {
                self.player!.removeTimeObserver(token)
            }
            self.timeObserverToken = nil
        }
        // Don't need to remove playerItem observers, they are automically removed
        // https://developer.apple.com/documentation/foundation/notificationcenter/1413994-removeobserver
    }
    
    
    
    
    // MARK: - End, called when the Audiofile finishes playing or the User dismisses it
    func end(user_uid: String) {
        if let metadata = metadata {
            self.sendAudioEvent(user_uid: user_uid, metadata: metadata)
        }
        self.player?.seek(to: .zero)
        self.player?.pause()
        self.stopHealthCheckTimer()
        self.removeObserver()
        self.player?.currentItem?.cancelPendingSeeks()
        self.player?.currentItem?.asset.cancelLoading()
        self.player?.rate = 0.0
        self.player = nil
        
        // cancel URLSession ????
        
        self.status = .undefined
    }
    
    // MARK: - Advanced Playback Functions related to Stalling
    
    private func tryToPlayIfStalled () {
        if self.status != .stalled {
            return
        }
        if player == nil || player?.currentItem == nil {
            return
        }
        if self.player!.currentItem!.isPlaybackLikelyToKeepUp || (self.timeBuffered() - self.currentTime) > 5.0 {
            try? self.play()
        }
    }
    
    
    
    // MARK: - HealthCheckTimer Methods: start, stop, fire
    
    private func startHealthCheckTimer () {
        self.healthCheckTimerDidFire()
        self.healthCheckTimer = Timer.scheduledTimer(timeInterval: 0.5,
                                            target: self,
                                            selector: #selector(healthCheckTimerDidFire),
                                            userInfo: nil,
                                            repeats: true)
    }
    
    private func stopHealthCheckTimer () {
        self.healthCheckTimer?.invalidate()
        self.healthCheckTimer = nil
    }
    
    @objc func healthCheckTimerDidFire () {
        if self.status == .completed || self.status == .undefined {
            return
        }
        self.tryToPlayIfStalled()
    }
    
    private func loadAssetIfNecessary () {
        if self.hasForcedDurationLoad {
            return
        }
        if self.isAssetLoaded() {
            return
        }
        
        if self.player?.status == .readyToPlay {
            self.forceLoadOfDuration()
            return
        }
        if self.player?.status == .failed {
            // something about delegate
            return
        }
    }
    
    private func isAssetLoaded () -> Bool {
        if let player = self.player {
            if let currentItem = player.currentItem {
                return currentItem.asset.isPlayable
            }
        }
        return false
    }
    
    private func forceLoadOfDuration () {
        self.hasForcedDurationLoad = true
    }
    
    
    
    // MARK: - Playback Functions
    // Play, Pause, Rewind 10, Fastforward 10, Seek
    
    func play () throws {
        if self.player == nil {
            throw AudioFileError.playerIsNil
        }
        self.player!.play()
        self.status = .playing
        self.startHealthCheckTimer()
    }
    
    func pause () throws {
        if self.player == nil {
            throw AudioFileError.playerIsNil
        }
        self.didPause = true
        self.player!.pause()
        self.status = .paused
        self.stopHealthCheckTimer()
    }
    
    func rewind (_ seconds: Float64) throws {
        if self.player == nil {
            throw AudioFileError.playerIsNil
        }
        self.didRewind = true
        let currentTime = player!.currentTime()
        var newTime = currentTime.seconds - seconds
        if newTime <= 0 {
            newTime = 0
        }
        player!.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
        
    }
    
    func fastForward (_ seconds: Float64) throws {
        if self.player == nil {
            throw AudioFileError.playerIsNil
        }
        self.didFastForward = true
        let currentTime = player!.currentTime()
        var newTime = CMTimeGetSeconds(currentTime) + seconds
        if newTime >= self.duration {
            newTime = self.duration
        }
        player!.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
    }
    
    func seek (to time: Double) throws {
        if self.player == nil {
            throw AudioFileError.playerIsNil
        }
        self.didSeek = true
        var timeScale: Int32 = 4800
        if self.timeScale != nil {
            timeScale = self.timeScale!
        }
        let cmTime = CMTimeMakeWithSeconds(time, preferredTimescale: timeScale)
        guard let _ = player else { return }
        player!.seek(to: cmTime)
    }
    
    
    // MARK: - Record Event to events database
    
    func sendAudioEvent(user_uid: String, metadata: FBAudioMetadata) {
        if let player = self.player {
            let secondsListened = player.currentTime().seconds
            var percListened = 0.0
            if self.duration != nil {
                percListened = secondsListened / self.duration
            }
            let data = [self.didPause, self.didStall, self.didRewind, self.didFastForward, self.didSeek]
            
            FBFirestore.sendAudioEvent(user_uid: user_uid, audio_metadata: metadata, secondsListened: secondsListened, percListened: percListened, data: data) { result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success( _):
                    print("Audio Event successfully recorded")
                }
                
            }
        }
    }
}
