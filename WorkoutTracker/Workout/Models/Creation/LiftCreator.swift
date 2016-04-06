import Foundation

public class LiftCreator {
    public private(set) var liftLoadAgent: LiftLoadAgent!
    
    public init(liftLoadAgent: LiftLoadAgent?) {
        self.liftLoadAgent = liftLoadAgent
    }
    
    public func createWithName(name: String) -> Lift {
        let lift = Lift(withName: name)
        lift.previousInstance = liftLoadAgent.loadLatestLiftWithName(name)
        
        return lift
    }
}
