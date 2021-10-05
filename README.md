# ImagetoVideo
Export video from image



### Installation
#### [CocoaPods](http://cocoapods.org)

To use ImageToVideo in a project, add the following to your project's Podfile:
```ruby
pod 'ImageToVideo'
```


## Usage

### Code

    var setting = RenderSettings()
    setting.size = CGSize(width: 1080, height: 720)
    setting.saveToLibrary = false
    setting.fps = 0.5
    imageAnimator = ImageAnimator(renderSettings: setting)
    imageAnimator?.images = arr
    imageAnimator?.render {
        print("render complete \(setting.outputURL)")
    }

