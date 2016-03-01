import UIKit
import Swinject

public class AppDelegate: UIResponder, UIApplicationDelegate {
    public var window: UIWindow?

    public func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)

        let storyboard = SwinjectStoryboard.create(name:WorkoutListStoryboardMetadata.name, bundle:nil,
            container:WorkoutListStoryboardMetadata.container)
        let rootController = storyboard.instantiateInitialViewController()
        
        window!.rootViewController = rootController
        window!.makeKeyAndVisible()
        
        return true
    }
}

