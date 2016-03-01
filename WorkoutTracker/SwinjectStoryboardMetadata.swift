import Foundation
import Swinject

public protocol SwinjectStoryboardMetadata {
    static var name: String { get }
    static var container: Container { get }
}

