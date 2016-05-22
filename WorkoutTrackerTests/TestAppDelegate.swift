import UIKit
import Swinject
@testable import WorkoutTracker

class TestAppDelegate: NSObject, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        self.window = UIWindow()
        self.window?.rootViewController = UIViewController()
        self.window!.makeKeyAndVisible()
        return true
    }
    
    class func setAsRootViewController(controller: UIViewController) {
        let testAppDelegate = UIApplication.sharedApplication().delegate as! TestAppDelegate
        testAppDelegate.window?.rootViewController = controller
        testAppDelegate.window?.setNeedsLayout()
        testAppDelegate.window?.layoutIfNeeded()
    }
    
    class func layoutWindow() {
        let testAppDelegate = UIApplication.sharedApplication().delegate as! TestAppDelegate
        testAppDelegate.window?.setNeedsLayout()
        testAppDelegate.window?.layoutIfNeeded()
    }
}
