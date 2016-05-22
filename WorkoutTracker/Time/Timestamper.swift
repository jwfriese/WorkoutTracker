import Foundation

class Timestamper {
    init() { }
    
    func getTimestamp() -> UInt {
        return UInt(NSDate().timeIntervalSince1970)
    }
}
