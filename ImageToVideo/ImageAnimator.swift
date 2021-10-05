//
//  ImageAnimator.swift
//  Image To Video
//
//  Created by TuyenLX on 05/10/2021.
//

import Foundation
import UIKit
import Photos

public class ImageAnimator {
    
    // Apple suggests a timescale of 600 because it's a multiple of standard video rates 24, 25, 30, 60 fps etc.
    static let kTimescale: Int32 = 600
    
    let settings: RenderSettings
    let videoWriter: VideoWriter
    var images: [UIImage]!
    
    var frameNum = 0
    
    public class func saveToLibrary(videoURL: URL) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else { return }
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
            }) { success, error in
                if !success {
                    print("Could not save video to photo library: \(String(describing: error))")
                }
            }
        }
    }
    
    public class func removeFileAtURL(fileURL: URL) {
        do {
            try FileManager.default.removeItem(atPath: fileURL.path)
        }
        catch {
                
        }
    }

    init(renderSettings: RenderSettings) {
        settings = renderSettings
        videoWriter = VideoWriter(renderSettings: settings)
    }

    func render(completion: (()->Void)?) {

        // The VideoWriter will fail if a file exists at the URL, so clear it out first.
        ImageAnimator.removeFileAtURL(fileURL: settings.outputURL)

        videoWriter.start()
        videoWriter.render(appendPixelBuffers: appendPixelBuffers) { [weak self] in
            guard let self = self else {return}
            if self.settings.saveToLibrary {
                ImageAnimator.saveToLibrary(videoURL: self.settings.outputURL)
            }
            completion?()
        }
    }

    // This is the callback function for VideoWriter.render()
    func appendPixelBuffers(writer: VideoWriter) -> Bool {

        let frameDuration = CMTimeMake(value: Int64(Double(ImageAnimator.kTimescale) / settings.fps), timescale: ImageAnimator.kTimescale)

        while !images.isEmpty {
            if writer.isReadyForData == false {
                // Inform writer we have more buffers to write.
                return false
            }

            let image = images.removeFirst()
            let presentationTime = CMTimeMultiply(frameDuration, multiplier: Int32(frameNum))
            let success = videoWriter.addImage(image: image, withPresentationTime: presentationTime)
            if success == false {
                fatalError("addImage() failed")
            }
            frameNum += 1
        }

        // Inform writer all buffers have been written.
        return true
    }
}
