import Quick
import Nimble
import WorkoutTracker
import Swinject

class LiftSetEditFormControllerFactorySpec: QuickSpec {
    override func spec() {
        describe("LiftSetEditFormControllerFactory") {
            var subject: LiftSetEditFormControllerFactory!
            var mockControllerContainer: Container!
            
            var mockWeightRepsController: WeightRepsEditFormViewController!
            
            beforeEach {
                mockControllerContainer = Container()
                
                mockWeightRepsController = WeightRepsEditFormViewController()
                mockControllerContainer.register(WeightRepsEditFormViewController.self) { resolver in
                    return mockWeightRepsController
                }
                
                subject = LiftSetEditFormControllerFactory(withControllerContainer: mockControllerContainer)
            }
            
            describe("The controller provided") {
                var controller: LiftSetEditFormController?
                
                context("For Weight/Reps template") {
                    beforeEach {
                        controller = subject.controllerForTemplate(.WeightReps)
                    }
                    
                    it("is the appropriate type") {
                        expect(controller as? WeightRepsEditFormViewController).to(beIdenticalTo(mockWeightRepsController))
                    }
                }
            }
        }
    }
}
