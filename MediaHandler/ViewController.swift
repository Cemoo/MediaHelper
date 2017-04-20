//
//  ViewController.swift
//  MediaHandler
//
//  Created by Gökhan Mandacı on 05/04/2017.
//  Copyright © 2017 Gökhan Mandacı. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let videoHelper = VideoHelper()
    let audioHelper = AudioHelper()
    let pictureHelper = PictureHelper()
    var isPlaying = false
    var cameraLayer: CALayer?

    @IBAction func btnTakePictureWithDefaultCameraAction(_ sender: Any) {
        // media.takePicture(self)
    }
    @IBAction func btnTakePictureWithCustomCameraAction(_ sender: Any) {
        pictureHelper.takePicture(self)
    }
    @IBAction func btnCaptureVideoWithDefaultCameraAction(_ sender: Any) {
        pictureHelper.takePicture(self)
    }
    @IBAction func btnCaptureVideoWithCustomCameraAction(_ sender: Any) {
        cameraLayer = videoHelper.createVideoView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 414.0), sessionPreset.high)
        self.view.layer.addSublayer(cameraLayer!)
        videoHelper.initCamera()
    }
    @IBAction func btnRecordAudioAction(_ sender: Any) {
        if audioHelper.isAudioRecording {
            audioHelper.stopAudioRecorder()
            audioHelper.isAudioRecording = false
        } else {
            audioHelper.startAudioRecorder()
            audioHelper.isAudioRecording = true
        }
    }
    @IBAction func btnPlayAudioAction(_ sender: Any) {
        if audioHelper.isPlayingAudio {
            // media.stopAudio()
            audioHelper.pauseAudioPlayer()
        } else {
            audioHelper.startAudioPlayer()
        }
    }
    @IBAction func btnRecAction(_ sender: Any) {
        if videoHelper.isVideoRecording {
            videoHelper.stopVideoRecording()
            videoHelper.isVideoRecording = false
        } else {
            videoHelper.startVideoRecording()
            videoHelper.isVideoRecording = true
        }
    }
    @IBAction func btnDeinitAction(_ sender: Any) {
        videoHelper.deinitCamera()
        cameraLayer?.removeFromSuperlayer()
    }
    @IBAction func btnPlayVideoAction(_ sender: Any) {
        if videoHelper.isPlayingVideo {
            videoHelper.pauseVideoPlayer()
            // media.stopVideoPlayer()
        } else {
            videoHelper.playVideoWith("test.mp4")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioHelper.setAudioRecorder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

