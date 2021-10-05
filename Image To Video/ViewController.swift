//
//  ViewController.swift
//  Image To Video
//
//  Created by TuyenLX on 05/10/2021.
//

import UIKit

class ViewController: UIViewController {
    
    var imageAnimator: ImageAnimator?

    override func viewDidLoad() {
        super.viewDidLoad()
        writeImage()
    }
    
    func writeImage() {
        let arr = Array(0...6).map { return "\($0)" }.map {
            return UIImage(named: $0)
        }.compactMap { return $0}
        var setting = RenderSettings()
        setting.size = CGSize(width: 1080, height: 720)
        setting.saveToLibrary = false
        setting.fps = 0.5
        imageAnimator = ImageAnimator(renderSettings: setting)
        imageAnimator?.images = arr
        imageAnimator?.render {
            print("render complete \(setting.outputURL)")
        }
    }
}

