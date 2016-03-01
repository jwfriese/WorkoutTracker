import Foundation

public class Workout {
    public private(set) var lifts: [Lift] = []
    
    public init() { }
    
    public func addLift(lift: Lift) {
        lifts.append(lift)
    }
}
