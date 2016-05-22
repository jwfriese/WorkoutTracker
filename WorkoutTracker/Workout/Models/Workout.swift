import Foundation

class Workout {
    private(set) var name: String!
    private(set) var timestamp: UInt
    private(set) var lifts: [Lift] = []
    
    init(withName name: String, timestamp: UInt) {
        self.name = name
        self.timestamp = timestamp
    }
    
    func addLift(lift: Lift) {
        lifts.append(lift)
        lift.workout = self
    }
    
    func liftWithName(name: String) -> Lift? {
        for lift in lifts {
            if lift.name == name {
                return lift
            }
        }
        
        return nil
    }
    
    func removeLiftWithName(name: String) {
        lifts = lifts.filter { $0.name != name }
    }
}
