import UIKit
import Swinject

class LiftTableHeaderViewProvider {
    func provideForLift(lift: Lift) -> UIStackView {
        let view = UIStackView()
        view.distribution = .FillEqually
        
        var subviews = [UIView]()
        switch (lift.dataTemplate as LiftDataTemplate) {
        case .WeightReps:
            subviews.append(createViewWithLabel("Weight"))
            subviews.append(createViewWithLabel("Reps"))
        case .HeightReps:
            subviews.append(createViewWithLabel("Height"))
            subviews.append(createViewWithLabel("Reps"))
        case .TimeInSeconds:
            subviews.append(createViewWithLabel("Time(sec)"))
        case .WeightTimeInSeconds:
            subviews.append(createViewWithLabel("Weight"))
            subviews.append(createViewWithLabel("Time(sec)"))
        }
        
        for subview in subviews {
            view.addArrangedSubview(subview)
        }
        
        return view
    }
    
    private func createViewWithLabel(label: String) -> UIView {
        let view = NSBundle.mainBundle().loadNibNamed("LiftTableHeaderViewColumnView", owner: nil, options: nil)[0] as? LiftTableHeaderViewColumnView
        view?.textLabel?.text = label
        return view!
    }
}

extension LiftTableHeaderViewProvider: Injectable {
    static func registerForInjection(container: Container) {
        container.register(LiftTableHeaderViewProvider.self) { _ in return LiftTableHeaderViewProvider() }
    }
}
