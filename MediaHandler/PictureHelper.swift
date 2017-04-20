//
//  PictureHelper.swift
//  MediaHandler
//
//  Created by Gökhan Mandacı on 05/04/2017.
//  Copyright © 2017 Gökhan Mandacı. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import Photos

class PictureHelper: SessionHelper {
    
    let imagePicker = UIImagePickerController()
    
    // MARK: Take Picture
    func takePicture(_ viewController: UIViewController) {
        imagePicker.sourceType = .camera
        imagePicker.delegate =  self
        UIApplication.shared.keyWindow?.rootViewController?.present(imagePicker, animated: true, completion: nil)
    }

}

extension PictureHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        if (mediaType == kUTTypeImage as String) {
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                selectedMediaData = UIImageJPEGRepresentation(pickedImage, 1)
                type = "image"
                saveImageDocumentDirectory(image: pickedImage)
                if imagePicker.sourceType != .photoLibrary {
                    UIImageWriteToSavedPhotosAlbum(pickedImage, nil, nil, nil)
                }
            }
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}
