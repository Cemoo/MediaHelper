//
//  PictureHelper.swift
//  MediaHandler
//
//  Created by Gökhan Mandacı on 05/04/2017.
//  Copyright © 2017 Gökhan Mandacı. All rights reserved.
//

import Foundation
import UIKit

class PictureHelper: NSObject {
    
    fileprivate let imagePicker = UIImagePickerController()
    
    // MARK: Take Picture
    func takePicture(_ viewController: UIViewController) {
        imagePicker.sourceType = .camera
        imagePicker.delegate =  self
        UIApplication.shared.keyWindow?.rootViewController?.present(imagePicker, animated: true, completion: nil)
    }
    
}

extension PictureHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("here \(info)")
    }
}
