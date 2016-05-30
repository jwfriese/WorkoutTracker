import UIKit

class ReplaceRootViewControllerSegue: UIStoryboardSegue {
    override func perform() {
        UIApplication.sharedApplication().keyWindow?.rootViewController = destinationViewController
    }
}
