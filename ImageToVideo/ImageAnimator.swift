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
    
    public let settings: RenderSettings
    public let videoWriter: VideoWriter
    public var images: [UIImage]!
    
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

    public init(renderSettings: RenderSettings) {
        settings = renderSettings
        videoWriter = VideoWriter(renderSettings: settings)
    }

    public func render(completion: (()->Void)?) {

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

        let frameDuration = CMTimeMake(value: Int64(ImageAnimator.kTimescale / settings.fps), timescale: ImageAnimator.kTimescale)
        var loopNumber = 0
        while !images.isEmpty {
            if writer.isReadyForData == false {
                // Inform writer we have more buffers to write.
                return false
            }
            autoreleasepool {
                let image: UIImage = images.first ?? UIImage()
                if loopNumber == settings.imageloop {
                    loopNumber = 0
                } else {
                    loopNumber += 1
                }
                let presentationTime = CMTimeMultiply(frameDuration, multiplier: Int32(frameNum))
                let success = writer.addImage(image: image, withPresentationTime: presentationTime)
                if success == false {
                    print("fale to add image")
                } else {
                    if loopNumber == 0 {
                        images.removeFirst()
                    }
                }
                frameNum += 1
            }
        }
        return true
    }
}
