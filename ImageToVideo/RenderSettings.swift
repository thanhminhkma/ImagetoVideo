//
//  RenderSettings.swift
//  Image To Video
//
//  Created by TuyenLX on 05/10/2021.
//

import AVFoundation
import UIKit
import Photos

struct RenderSettings {
    var size : CGSize = .zero
    var fps: Double = 6   // frames per second
    var avCodecKey: AVVideoCodecType = AVVideoCodecType.h264
    var videoFilename: String = "render"
    var videoFilenameExt: String = "mp4"
    var saveToLibrary: Bool = true

    var outputURL: URL {
        let fileManager = FileManager.default
        if let tmpDirURL = try? fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true) {
            return tmpDirURL.appendingPathComponent(videoFilename).appendingPathExtension(videoFilenameExt)
        }
        fatalError("URLForDirectory() failed")
    }
}
