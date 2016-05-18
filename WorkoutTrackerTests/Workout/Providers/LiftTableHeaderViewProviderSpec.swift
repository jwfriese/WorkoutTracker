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
                    lift = Lift(withName: "", dataTemplate: .WeightReps)
                    
                    view = subject.provideForLift(lift!)
                }
                
                it("has two subviews") {
                    expect(view?.arrangedSubviews.count).to(equal(2))
                }
                
                it("spaces the subviews evenly") {
                    expect(view?.distribution).to(equal(UIStackViewDistribution.FillEqually))
                }
                
                // given("has two subviews")
                describe("the two subviews") {
                    var weightSubview: LiftTableHeaderViewColumnView?
                    var repsSubview: LiftTableHeaderViewColumnView?
                    
                    beforeEach {
                        weightSubview = view?.arrangedSubviews[0] as? LiftTableHeaderViewColumnView
                        repsSubview = view?.arrangedSubviews[1] as? LiftTableHeaderViewColumnView
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
