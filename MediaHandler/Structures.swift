//
//  Structures.swift
//  MediaHandler
//
//  Created by Gökhan Mandacı on 05/04/2017.
//  Copyright © 2017 Gökhan Mandacı. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit

let sessionPreset = SessionPreset()
struct SessionPreset {
    let low = AVCaptureSessionPresetLow
    let high = AVCaptureSessionPresetHigh
    let photo = AVCaptureSessionPresetPhoto
    let medium = AVCaptureSessionPresetMedium
    let _352x288 = AVCaptureSessionPreset352x288
    let _640x480 = AVCaptureSessionPreset640x480
    let _1280x720 = AVCaptureSessionPreset1280x720
    let _1920x1080 = AVCaptureSessionPreset1920x1080
}

let videoGravity = VideoGravity()
struct VideoGravity {
    let aspect = AVLayerVideoGravityResizeAspect
    let aspectFill = AVLayerVideoGravityResizeAspectFill
    let resize = AVLayerVideoGravityResize
}
