//
//  UploadHelper.swift
//  MediaHandler
//
//  Created by Gökhan Mandacı on 20/04/2017.
//  Copyright © 2017 Gökhan Mandacı. All rights reserved.
//

import Foundation
import AVFoundation
import AssetsLibrary

class SessionHelper: NSObject, URLSessionTaskDelegate {
    
    var exportSession: AVAssetExportSession!
    var videoAssetURL: URL!
    var selectedMediaData: Data?
    var type = ""
    var selectedMediaFileName: String!
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let progress = (Float(totalBytesSent) / Float(totalBytesExpectedToSend))
        print(progress)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print(error?.localizedDescription as Any)
    }
    
    public func saveImageDocumentDirectory(image: UIImage) {
        let fileManager = FileManager.default
        let pathstr = (getDirectoryPath() as NSString).appendingPathComponent("pickedImage.jpg")
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        fileManager.createFile(atPath: pathstr as String, contents: imageData, attributes: nil)
        selectedMediaFileName = "file:///\(pathstr)"
    }
    
    public func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    public func getImage() -> UIImage? {
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent("pickedImage.jpg")
        if fileManager.fileExists(atPath: imagePAth){
            return UIImage(contentsOfFile: imagePAth)
        }else{
            return nil
        }
    }
    
}
