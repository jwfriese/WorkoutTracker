import Foundation

public class LiftCreator {
        public private(set) var liftLoadAgent: LiftLoadAgent!

        public init(liftLoadAgent: LiftLoadAgent?) {
                self.liftLoadAgent = liftLoadAgent
        }

        public func createWithName(name: String, dataTemplate: LiftDataTemplate) -> Lift {
                let lift = Lift(withName: name, dataTemplate: dataTemplate)
                lift.previousInstance = liftLoadAgent.loadLatestLiftWithName(name)

                return lift
        }
}
