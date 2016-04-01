import UIKit
import Swinject

public class AppDelegate: UIResponder, UIApplicationDelegate {
    public var window: UIWindow?

    public func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)

        let startupMetadata = StartupStoryboardMetadata()
        
        let storyboard = SwinjectStoryboard.create(name: startupMetadata.name, bundle: nil,
            container: startupMetadata.container)
        let rootController = storyboard.instantiateInitialViewController() as! StartupViewController
        let rootNavigationController = UINavigationController(rootViewController: rootController)
        
        window!.rootViewController = rootNavigationController
        window!.makeKeyAndVisible()
        
        return true
    }
}

