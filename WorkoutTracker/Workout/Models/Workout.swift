import Foundation

public class Workout {
    public private(set) var name: String!
    public private(set) var timestamp: UInt
    public private(set) var lifts: [Lift] = []
    
    public init(withName name: String, timestamp: UInt) {
        self.name = name
        self.timestamp = timestamp
    }
    
    public func addLift(lift: Lift) {
        lifts.append(lift)
        lift.workout = self
    }
    
    public func liftWithName(name: String) -> Lift? {
        for lift in lifts {
            if lift.name == name {
                return lift
            }
        }
        
        return nil
    }
    
    public func removeLiftWithName(name: String) {
        lifts = lifts.filter { $0.name != name }
    }
}
