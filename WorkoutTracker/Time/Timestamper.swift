import Foundation

public class Timestamper {
    public init() { }
    
    public func getTimestamp() -> Int {
        return Int(NSDate().timeIntervalSince1970)
    }
}
