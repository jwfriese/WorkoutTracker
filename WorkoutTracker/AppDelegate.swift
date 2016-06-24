import UIKit
import Swinject

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let startupMetadata = StartupStoryboardMetadata()
        
        let rootController = startupMetadata.initialViewController
        let rootNavigationController = UINavigationController(rootViewController: rootController)
        
        window!.rootViewController = rootNavigationController
        window!.makeKeyAndVisible()
        
        return true
    }
}

