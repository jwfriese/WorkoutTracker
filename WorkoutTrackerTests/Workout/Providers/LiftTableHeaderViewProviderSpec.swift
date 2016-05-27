import Quick
import Nimble
import Swinject
@testable import WorkoutTracker

class LiftTableHeaderViewProviderSpec: QuickSpec {
    override func spec() {
        describe("LiftTableHeaderViewProvider") {
            var subject: LiftTableHeaderViewProvider!
            
            beforeEach {
                let container = Container()
                LiftTableHeaderViewProvider.registerForInjection(container)
                subject = container.resolve(LiftTableHeaderViewProvider.self)
            }
            
            describe("The header view created for the given lift") {
                var view: UIStackView?
                var lift: Lift?
                
                context("When the lift template is Weight/Reps") {
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
                
                context("When the lift template is Height/Reps") {
                    beforeEach {
                        lift = Lift(withName: "", dataTemplate: .HeightReps)
                        
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
                            expect(weightSubview?.textLabel?.text).to(equal("Height"))
                        }
                        
                        it("has a 'reps' component") {
                            expect(repsSubview?.textLabel?.text).to(equal("Reps"))
                        }
                    }
                }
                
                context("When the lift template is TimeInSeconds") {
                    beforeEach {
                        lift = Lift(withName: "", dataTemplate: .TimeInSeconds)
                        
                        view = subject.provideForLift(lift!)
                    }
                    
                    it("has one subview") {
                        expect(view?.arrangedSubviews.count).to(equal(1))
                    }
                    
                    it("spaces the subviews evenly") {
                        expect(view?.distribution).to(equal(UIStackViewDistribution.FillEqually))
                    }
                    
                    // given("has one subview")
                    describe("the one subview") {
                        var timeInSecondsSubview: LiftTableHeaderViewColumnView?
                        
                        beforeEach {
                            timeInSecondsSubview = view?.arrangedSubviews[0] as? LiftTableHeaderViewColumnView
                        }
                        
                        it("has a 'Time(sec)' component") {
                            expect(timeInSecondsSubview?.textLabel?.text).to(equal("Time(sec)"))
                        }
                    }
                }
                
                context("When the lift template is Weight/Reps") {
                    beforeEach {
                        lift = Lift(withName: "", dataTemplate: .WeightTimeInSeconds)
                        
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
                        
                        it("has a 'time(sec)' component") {
                            expect(repsSubview?.textLabel?.text).to(equal("Time(sec)"))
                        }
                    }
                }
            }
        }
    }
}
