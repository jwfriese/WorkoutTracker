import Foundation

public class WorkoutListItem {
    public init(withTimestamp timestamp: Int) {
        self.timestamp = timestamp
    }
    
    public private(set) var timestamp: Int
}
