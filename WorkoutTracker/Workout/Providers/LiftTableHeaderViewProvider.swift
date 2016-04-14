import UIKit

public class LiftTableHeaderViewProvider {
    public init() { }
    
    public func provideForLift(lift: Lift) -> UIStackView {
        let view = UIStackView()
        view.distribution = .FillEqually
        let setView = NSBundle.mainBundle().loadNibNamed("LiftTableHeaderViewColumnView", owner: nil, options: nil)[0] as? LiftTableHeaderViewColumnView
        setView?.textLabel?.text = "Set"
        view.addArrangedSubview(setView!)
        
        let weightView = NSBundle.mainBundle().loadNibNamed("LiftTableHeaderViewColumnView", owner: nil, options: nil)[0] as? LiftTableHeaderViewColumnView
        weightView?.textLabel?.text = "Weight"
        view.addArrangedSubview(weightView!)
        
        let repsView = NSBundle.mainBundle().loadNibNamed("LiftTableHeaderViewColumnView", owner: nil, options: nil)[0] as? LiftTableHeaderViewColumnView
        repsView?.textLabel?.text = "Reps"
        view.addArrangedSubview(repsView!)
        
        return view
    }
}
