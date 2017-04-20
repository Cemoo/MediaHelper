//
//  HandleMedia.swift
//  MediaHandler
//
//  Created by Gökhan Mandacı on 05/04/2017.
//  Copyright © 2017 Gökhan Mandacı. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

class VideoHelper: SessionHelper {
    
    fileprivate var previewLayer: AVCaptureVideoPreviewLayer!
    fileprivate var cameraSession: AVCaptureSession!
    fileprivate let fileOutput = AVCaptureMovieFileOutput()
    fileprivate var videoPlayer = AVPlayer()
    fileprivate var cameraFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    fileprivate var micDevice: AVCaptureDevice? = {
        return AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)
    }()
    
    // MARK: Params
    var isPlayingVideo = false
    var isVideoRecording = false
    fileprivate var isVideoPlayerPaused = false
    fileprivate var videoPauseTime: CMTime!
    fileprivate var recordedVideoName = "video.mp4"
    
    /// Default value, user can change
    open func setRecordedVideoName(_ name: String) {
        recordedVideoName = name
    }
    
    /// Singleton
    open class var shared: VideoHelper {
        struct Singleton {
            static let instance = VideoHelper()
        }
        return Singleton.instance
    }
    
    // MARK: Video
    func createVideoView(frame: CGRect, _ sessionPreset: String, _ videoGravity: String = AVLayerVideoGravityResizeAspectFill) -> AVCaptureVideoPreviewLayer {
        cameraFrame = frame
        cameraSession = AVCaptureSession()
        cameraSession.sessionPreset = sessionPreset
        let preview =  AVCaptureVideoPreviewLayer(session: cameraSession)
        preview?.frame = frame
        preview?.videoGravity = videoGravity
        return preview!
    }
    
    func initCamera() {
        setupCameraSession()
        cameraSession.addOutput(fileOutput)
        cameraSession.addInput(deviceInputFrom(micDevice))
        cameraSession.startRunning()
    }
    
    func deinitCamera() {
        cameraSession.stopRunning()
    }
    
    func startVideoRecording() {
        //fileOutput.movieFragmentInterval = kCMTimeInvalid
        fileOutput.startRecording(toOutputFileURL: makePathUrl(recordedVideoName, willRemoveExisting: true), recordingDelegate: self)
        isVideoRecording = true
    }
    
    func stopVideoRecording() {
        fileOutput.stopRecording()
        isVideoRecording = false
    }
    
    func playVideoWith(_ name: String, videoGravity: String = AVLayerVideoGravityResizeAspectFill) {
        if checkVideoAvailabilityBy(name) {
            videoPlayer = AVPlayer(url: makePathUrl(name, willRemoveExisting: false))
            if cameraFrame.width != 0 {
                let avPlayerLayer = AVPlayerLayer(player: videoPlayer)
                avPlayerLayer.frame = cameraFrame
                avPlayerLayer.videoGravity = videoGravity
                UIApplication.shared.keyWindow?.rootViewController?.view.layer.addSublayer(avPlayerLayer)
                videoPlayer.seek(to: kCMTimeZero)
                if isVideoPlayerPaused {
                    videoPlayer.seek(to: videoPauseTime)
                    isVideoPlayerPaused = false
                }
                videoPlayer.play()
                isPlayingVideo = true
            } else {
                let playerViewController = AVPlayerViewController()
                playerViewController.player = videoPlayer
                UIApplication.shared.keyWindow?.rootViewController?.present(playerViewController, animated: true, completion: {
                    playerViewController.player?.play()
                })
            }
            
        } else {
            print("video does not exist!")
        }
    }
    
    func stopVideoPlayer() {
        videoPlayer.pause()
        videoPlayer.seek(to: kCMTimeZero)
        isVideoPlayerPaused = false
        isPlayingVideo = false
    }
    
    func pauseVideoPlayer() {
        videoPauseTime = videoPlayer.currentTime()
        videoPlayer.pause()
        isVideoPlayerPaused = true
        isPlayingVideo = false
    }
    
    fileprivate func deviceInputFrom(_ device: AVCaptureDevice?) -> AVCaptureDeviceInput? {
        guard let validDevice = device else { return nil }
        do {
            return try AVCaptureDeviceInput(device: validDevice)
        } catch let outError {
            print("Device setup error occured \(outError)")
            return nil
        }
    }
    
    fileprivate func setupCameraSession() {
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) as AVCaptureDevice
        do {
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            cameraSession.beginConfiguration()
            if (cameraSession.canAddInput(deviceInput) == true) {
                cameraSession.addInput(deviceInput)
            }
            let dataOutput = AVCaptureVideoDataOutput()
            dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange as UInt32)]
            dataOutput.alwaysDiscardsLateVideoFrames = true
            if (cameraSession.canAddOutput(dataOutput) == true) {
                cameraSession.addOutput(dataOutput)
            }
            cameraSession.commitConfiguration()
        }
        catch let error as NSError {
            NSLog("\(error), \(error.localizedDescription)")
        }
    }
    
    fileprivate func makePathUrl(_ tail: String, willRemoveExisting: Bool) -> URL {
        return URL(fileURLWithPath: makePathString(tail, willRemoveExisting: willRemoveExisting))
    }
    
    fileprivate func makePathString(_ tail: String, willRemoveExisting: Bool) -> String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        if Foundation.FileManager().fileExists(atPath: path) {
            if willRemoveExisting {
                do {
                    try Foundation.FileManager().removeItem(atPath: path)
                } catch _ {
                }
            }
        }
        return "\(path)/\(tail)"
    }
    
    fileprivate func checkVideoAvailabilityBy(_ name: String) -> Bool {
        if Foundation.FileManager().fileExists(atPath: makePathString(name, willRemoveExisting: false)) {
            return true
        } else {
            return false
        }
    }

}

extension VideoHelper: AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureFileOutputRecordingDelegate {
    internal func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
        print("recording started to \(fileURL!)")
    }
    
    fileprivate func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("recording finished, \(flag)")
    }
    
    internal func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        print("finished recording to output file  to \(outputFileURL!)")
    }
}
