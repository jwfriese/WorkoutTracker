import Foundation

class LiftCreator {
        private(set) var liftLoadAgent: LiftLoadAgent!

        init(liftLoadAgent: LiftLoadAgent?) {
                self.liftLoadAgent = liftLoadAgent
        }

        func createWithName(name: String, dataTemplate: LiftDataTemplate) -> Lift {
                let lift = Lift(withName: name, dataTemplate: dataTemplate)
                lift.previousInstance = liftLoadAgent.loadLatestLiftWithName(name)

                return lift
        }
}
