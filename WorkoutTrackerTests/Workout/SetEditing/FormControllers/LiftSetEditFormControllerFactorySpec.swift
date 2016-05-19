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
            var mockHeightRepsController: HeightRepsEditFormViewController!
            var mockTimeInSecondsController: TimeInSecondsEditFormViewController!
            
            beforeEach {
                mockControllerContainer = Container()
                
                mockWeightRepsController = WeightRepsEditFormViewController()
                mockHeightRepsController = HeightRepsEditFormViewController()
                mockTimeInSecondsController = TimeInSecondsEditFormViewController()
                mockControllerContainer.register(WeightRepsEditFormViewController.self) { resolver in
                    return mockWeightRepsController
                }
                
                mockControllerContainer.register(HeightRepsEditFormViewController.self) { resolver in
                    return mockHeightRepsController
                }
                
                mockControllerContainer.register(TimeInSecondsEditFormViewController.self) { resolver in
                    return mockTimeInSecondsController
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
                
                context("For Height/Reps template") {
                    beforeEach {
                        controller = subject.controllerForTemplate(.HeightReps)
                    }
                    
                    it("is the appropriate type") {
                        expect(controller as? HeightRepsEditFormViewController).to(beIdenticalTo(mockHeightRepsController))
                    }
                }
                
                context("For TimeInSeconds template") {
                    beforeEach {
                        controller = subject.controllerForTemplate(.TimeInSeconds)
                    }
                    
                    it("is the appropriate type") {
                        expect(controller as? TimeInSecondsEditFormViewController).to(beIdenticalTo(mockTimeInSecondsController))
                    }
                }
            }
        }
    }
}
