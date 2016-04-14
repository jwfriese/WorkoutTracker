import Quick
import Nimble
import WorkoutTracker

class LiftTableHeaderViewProviderSpec: QuickSpec {
    override func spec() {
        
        describe("LiftTableHeaderViewProvider") {
            var subject: LiftTableHeaderViewProvider!
            
            beforeEach {
                subject = LiftTableHeaderViewProvider()
            }
            
            describe("The header view created for the given lift") {
                var view: UIStackView?
                var lift: Lift?
                
                beforeEach {
                    lift = Lift(withName: "")
                    
                    view = subject.provideForLift(lift!)
                }
                
                it("has three subviews") {
                    expect(view?.arrangedSubviews.count).to(equal(3))
                }
                
                it("spaces the subviews evenly") {
                    expect(view?.distribution).to(equal(UIStackViewDistribution.FillEqually))
                }
                
                // given("has three subviews")
                describe("the three subviews") {
                    var setSubview: LiftTableHeaderViewColumnView?
                    var weightSubview: LiftTableHeaderViewColumnView?
                    var repsSubview: LiftTableHeaderViewColumnView?
                    
                    beforeEach {
                        setSubview = view?.arrangedSubviews[0] as? LiftTableHeaderViewColumnView
                        weightSubview = view?.arrangedSubviews[1] as? LiftTableHeaderViewColumnView
                        repsSubview = view?.arrangedSubviews[2] as? LiftTableHeaderViewColumnView
                    }
                    
                    it("has a 'set' component") {
                        expect(setSubview?.textLabel?.text).to(equal("Set"))
                    }
                    
                    it("has a 'weight' component") {
                        expect(weightSubview?.textLabel?.text).to(equal("Weight"))
                    }
                    
                    it("has a 'reps' component") {
                        expect(repsSubview?.textLabel?.text).to(equal("Reps"))
                    }
                }
            }
        }
    }
}
