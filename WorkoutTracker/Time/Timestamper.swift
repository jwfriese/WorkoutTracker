import Foundation
import Swinject

class Timestamper {    
    func getTimestamp() -> UInt {
        return UInt(NSDate().timeIntervalSince1970)
    }
}

extension Timestamper: Injectable {
    static func registerForInjection(container: Container) {
        container.register(Timestamper.self) { _ in return Timestamper() }
    }
}
