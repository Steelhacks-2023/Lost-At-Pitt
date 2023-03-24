import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyDaeA4j77KOqMdW3WfIfhXHLDOEUN_Z3Wo")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
