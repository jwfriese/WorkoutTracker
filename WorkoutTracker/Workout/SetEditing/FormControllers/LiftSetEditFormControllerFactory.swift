import UIKit
import Swinject

class LiftSetEditFormControllerFactory {
    private(set) var controllerContainer: Container!
    
    init(withControllerContainer controllerContainer: Container?) {
        self.controllerContainer = controllerContainer
    }
    
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
