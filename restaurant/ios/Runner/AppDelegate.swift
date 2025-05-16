import Flutter
import UIKit
import GoogleMaps
import Photos

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyCfhx7ahLorEsPqplRnSTfhDbc47yW9c_4")
    GeneratedPluginRegistrant.register(with: self)
        let controller = window?.rootViewController as! FlutterViewController
            let channel = FlutterMethodChannel(name: "image_saver", binaryMessenger: controller.binaryMessenger)

            channel.setMethodCallHandler { (call, result) in
                if call.method == "saveImage" {
                    guard let args = call.arguments as? [String: Any],
                          let filePath = args["filePath"] as? String else {
                        result(FlutterError(code: "INVALID_PATH", message: "File path is null", details: nil))
                        return
                    }
                    self.saveImageToGallery(filePath: filePath, result: result)
                } else {
                    result(FlutterMethodNotImplemented)
                }
            }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    private func saveImageToGallery(filePath: String, result: @escaping FlutterResult) {
          let image = UIImage(contentsOfFile: filePath)
          if let image = image {
              UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
              result(true)
          } else {
              result(FlutterError(code: "SAVE_FAILED", message: "Failed to save image", details: nil))
          }
      }
}
