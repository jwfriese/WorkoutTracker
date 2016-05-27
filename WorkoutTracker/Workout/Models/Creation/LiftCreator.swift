import Foundation
import Swinject

class LiftCreator {
    private(set) var liftLoadAgent: LiftLoadAgent!
    
    func createWithName(name: String, dataTemplate: LiftDataTemplate) -> Lift {
        let lift = Lift(withName: name, dataTemplate: dataTemplate)
        lift.previousInstance = liftLoadAgent.loadLatestLiftWithName(name)
        
        return lift
    }
}

extension LiftCreator: Injectable {
    static func registerForInjection(container: Container) {
        container.register(LiftCreator.self) { resolver in
            let instance = LiftCreator()
            
            instance.liftLoadAgent = resolver.resolve(LiftLoadAgent.self)
            
            return instance
        }
    }
}
