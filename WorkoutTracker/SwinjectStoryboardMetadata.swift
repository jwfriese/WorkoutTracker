import UIKit
import Swinject

public protocol SwinjectStoryboardMetadata {
    var name: String { get }
    var initialViewController: UIViewController { get }
    var container: Container { get }
}

