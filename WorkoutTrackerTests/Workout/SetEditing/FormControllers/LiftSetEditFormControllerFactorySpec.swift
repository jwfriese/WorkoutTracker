import Quick
import Nimble
import Swinject
@testable import WorkoutTracker

class LiftSetEditFormControllerFactorySpec: QuickSpec {
    override func spec() {
        describe("LiftSetEditFormControllerFactory") {
            var subject: LiftSetEditFormControllerFactory!
            
            beforeEach {
                let container = Container()
                LiftSetEditFormControllerFactory.registerForInjection(container)
                subject = container.resolve(LiftSetEditFormControllerFactory.self)
            }
            
            describe("Its injection") {
                it("sets its controller container") {
                    expect(subject.controllerContainer).toNot(beNil())
                }
                
                describe("The controller container dependency") {
                    it("can produce a WeightRepsEditFormViewController") {
                        let controller = subject.controllerContainer.resolve(WeightRepsEditFormViewController.self)
                        expect(controller).toNot(beNil())
                    }
                    
                    it("can produce a HeightRepsEditFormViewController") {
                        let controller = subject.controllerContainer.resolve(HeightRepsEditFormViewController.self)
                        expect(controller).toNot(beNil())
                    }
                    
                    it("can produce a TimeInSecondsEditFormViewController") {
                        let controller = subject.controllerContainer.resolve(TimeInSecondsEditFormViewController.self)
                        expect(controller).toNot(beNil())
                    }
                    
                    it("can produce a WeightTimeInSecondsEditFormViewController") {
                        let controller = subject.controllerContainer.resolve(WeightTimeInSecondsEditFormViewController.self)
                        expect(controller).toNot(beNil())
                    }
                }
            }
            
            describe("The controller provided") {
                var controller: LiftSetEditFormController?
                
                context("For Weight/Reps template") {
                    beforeEach {
                        controller = subject.controllerForTemplate(.WeightReps)
                    }
                    
                    it("is the appropriate type") {
                        expect(controller as? WeightRepsEditFormViewController).toNot(beNil())
                    }
                }
                
                context("For Height/Reps template") {
                    beforeEach {
                        controller = subject.controllerForTemplate(.HeightReps)
                    }
                    
                    it("is the appropriate type") {
                        expect(controller as? HeightRepsEditFormViewController).toNot(beNil())
                    }
                }
                
                context("For TimeInSeconds template") {
                    beforeEach {
                        controller = subject.controllerForTemplate(.TimeInSeconds)
                    }
                    
                    it("is the appropriate type") {
                        expect(controller as? TimeInSecondsEditFormViewController).toNot(beNil())
                    }
                }
                
                context("For Weight/TimeInSeconds template") {
                    beforeEach {
                        controller = subject.controllerForTemplate(.WeightTimeInSeconds)
                    }
                    
                    it("is the appropriate type") {
                        expect(controller as? WeightTimeInSecondsEditFormViewController).toNot(beNil())
                    }
                }
            }
        }
    }
}
