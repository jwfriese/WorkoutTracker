import UIKit
import Swinject

@UIApplicationMain
public class AppDelegate: UIResponder, UIApplicationDelegate {

    public var window: UIWindow?

    public func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)

        let workoutMetadata = WorkoutStoryboardMetadata()
        let storyboard = SwinjectStoryboard.create(name:workoutMetadata.name, bundle:nil,
            container:workoutMetadata.container)
        let rootController = storyboard.instantiateInitialViewController()
        
        window!.rootViewController = rootController
        window!.makeKeyAndVisible()
        
        return true
    }
}

