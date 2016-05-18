import UIKit
import Swinject

public class LiftSetEditFormControllerFactory {
    public private(set) var controllerContainer: Container!
    
    public init(withControllerContainer controllerContainer: Container?) {
        self.controllerContainer = controllerContainer
    }
    
    public func controllerForTemplate(template: LiftDataTemplate) -> LiftSetEditFormController? {
        
        let controller = controllerContainer.resolve(WeightRepsEditFormViewController.self)
        
        return controller
    }
}
