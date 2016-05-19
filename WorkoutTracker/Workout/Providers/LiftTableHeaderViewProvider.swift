import UIKit

public class LiftTableHeaderViewProvider {
    public init() { }
    
    public func provideForLift(lift: Lift) -> UIStackView {
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
        default: break
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
