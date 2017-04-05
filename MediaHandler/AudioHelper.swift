//
//  AudioHelper.swift
//  MediaHandler
//
//  Created by Gökhan Mandacı on 05/04/2017.
//  Copyright © 2017 Gökhan Mandacı. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

class AudioHelper: NSObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    fileprivate var audioSession: AVAudioSession!
    fileprivate var audioRecorder: AVAudioRecorder?
    fileprivate var audioPlayer : AVAudioPlayer!
    
    /// Params
    var isAudioRecording = false
    var isPlayingAudio = false
    fileprivate var audioPauseTime: TimeInterval = 0
    fileprivate var recordedAudioName = "record.aac"
    
    /// Default value, user can change
    open func setRecordedAudioName(_ name: String) {
        recordedAudioName = name
    }
    
    // MARK: Audio Recorder
    func setAudioRecorder() {
        let soundFileURL = getDocumentsDirectory()
        let recordSettings =
            [AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
             AVEncoderBitRateKey: 320000,
             AVFormatIDKey : kAudioFormatMPEG4AAC,
             AVNumberOfChannelsKey: 2,
             AVSampleRateKey: 44100.0] as [String : Any]
        let audioSession = AVAudioSession.sharedInstance()
        do {
            if #available(iOS 10.0, *) {
                try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, mode: AVAudioSessionModeVideoRecording, options: AVAudioSessionCategoryOptions.defaultToSpeaker)
            } else {
                try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
            }
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        do {
            try audioRecorder = AVAudioRecorder(url: soundFileURL, settings: recordSettings)
            audioRecorder?.delegate = self
            audioRecorder?.prepareToRecord()
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
    }
    
    
    
    func startAudioRecorder() {
        if audioRecorder?.isRecording == false {
            audioRecorder?.record()
            isAudioRecording = true
        }
    }
    
    func stopAudioRecorder() {
        if audioRecorder?.isRecording == true {
            audioRecorder?.stop()
            isAudioRecording = false
        }
    }
    
    // MARK: Audio Player
    func startAudioPlayer() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        if audioRecorder?.isRecording == false {
            do {
                try audioPlayer = AVAudioPlayer(contentsOf:
                    (audioRecorder?.url)!)
                audioPlayer!.delegate = self
                if audioPauseTime != 0 {
                    audioPlayer.currentTime = audioPauseTime
                }
                audioPlayer!.prepareToPlay()
                audioPlayer!.play()
                isPlayingAudio = true
            } catch let error as NSError {
                print("audioPlayer error: \(error.localizedDescription)")
            }
        }
    }
    
    func stopAudioPlayer() {
        audioPlayer.stop()
        audioPauseTime = 0
        isPlayingAudio = false
        print("playing stopped")
    }
    
    func pauseAudioPlayer() {
        audioPlayer.pause()
        audioPauseTime = audioPlayer.currentTime
        isPlayingAudio = false
        print("playing paused")
    }
    
    fileprivate func getDocumentsDirectory() -> URL {
        let fileMgr = Foundation.FileManager.default
        let dirPaths = fileMgr.urls(for: .documentDirectory, in: .userDomainMask)
        return dirPaths[0].appendingPathComponent(recordedAudioName)
    }
    
}
