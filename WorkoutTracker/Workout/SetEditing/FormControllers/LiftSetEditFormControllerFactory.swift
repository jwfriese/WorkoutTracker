import UIKit
import Swinject

public class LiftSetEditFormControllerFactory {
    public private(set) var controllerContainer: Container!
    
    public init(withControllerContainer controllerContainer: Container?) {
        self.controllerContainer = controllerContainer
    }
    
    public func controllerForTemplate(template: LiftDataTemplate) -> LiftSetEditFormController? {
        switch (template) {
        case .WeightReps:
            return controllerContainer.resolve(WeightRepsEditFormViewController.self)
        case .HeightReps:
            return controllerContainer.resolve(HeightRepsEditFormViewController.self)
        case .TimeInSeconds:
            return controllerContainer.resolve(TimeInSecondsEditFormViewController.self)
        default:
            return nil
        }
    }
}
