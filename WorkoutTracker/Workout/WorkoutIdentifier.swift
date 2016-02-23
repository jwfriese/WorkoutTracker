import Foundation

public class WorkoutIdentifier {
    public init(withTimestamp timestamp: Int) {
        self.timestamp = timestamp
    }
    
    public private(set) var timestamp: Int
}
