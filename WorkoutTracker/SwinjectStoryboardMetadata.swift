import Foundation
import Swinject

public protocol SwinjectStoryboardMetadata {
    var name: String { get }
    var container: Container { get }
}

