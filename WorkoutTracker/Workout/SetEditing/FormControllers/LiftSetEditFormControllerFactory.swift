import UIKit
import Swinject

class LiftSetEditFormControllerFactory {
    private(set) var controllerContainer: Container!
    
    func controllerForTemplate(template: LiftDataTemplate) -> LiftSetEditFormController? {
        switch (template) {
        case .WeightReps:
            return controllerContainer.resolve(WeightRepsEditFormViewController.self)
        case .HeightReps:
            return controllerContainer.resolve(HeightRepsEditFormViewController.self)
        case .TimeInSeconds:
            return controllerContainer.resolve(TimeInSecondsEditFormViewController.self)
        case .WeightTimeInSeconds:
            return controllerContainer.resolve(WeightTimeInSecondsEditFormViewController.self)
        }
    }
}

extension LiftSetEditFormControllerFactory: Injectable {
    static func registerForInjection(container: Container) {
        container.register(LiftSetEditFormControllerFactory.self) { resolver in
            let instance = LiftSetEditFormControllerFactory()
            
            let container = Container()
            WeightRepsEditFormViewController.registerForInjection(container)
            HeightRepsEditFormViewController.registerForInjection(container)
            TimeInSecondsEditFormViewController.registerForInjection(container)
            WeightTimeInSecondsEditFormViewController.registerForInjection(container)
            
            instance.controllerContainer = container
            return instance
        }
    }
}
