import Foundation

public class Timestamper {
    public init() { }
    
    public func getTimestamp() -> UInt {
        return UInt(NSDate().timeIntervalSince1970)
    }
}
