import Quick
import Nimble
import Swinject
@testable import WorkoutTracker

class WorkoutListStoryboardMetadataSpec: QuickSpec {
    override func spec() {
        describe("WorkoutListStoryboardMetadata") {
            var subject: WorkoutListStoryboardMetadata!
            
            beforeEach {
                subject = WorkoutListStoryboardMetadata()
            }
            
            it("has the correct name") {
                expect(subject.name).to(equal("WorkoutList"))
            }
            
            describe("The storyboard created using the metadata") {
                var storyboard: SwinjectStoryboard!
                var container: Container!
                
                beforeEach {
                    container = subject.container
                    storyboard = SwinjectStoryboard.create(name: subject.name, bundle: nil, container: container)
                }
                
                describe("The container") {
                    var timestamper: Timestamper?
                    var workoutSaveAgent: WorkoutSaveAgent?
                    var liftSaveAgent: LiftSaveAgent?
                    var localStorageWorker: LocalStorageWorker?
                    var workoutSerializer: WorkoutSerializer?
                    var liftSerializer: LiftSerializer?
                    var workoutLoadAgent: WorkoutLoadAgent?
                    var liftLoadAgent: LiftLoadAgent?
                    var liftHistoryIndexLoader: LiftHistoryIndexLoader?
                    var workoutDeserializer: WorkoutDeserializer?
                    var liftSetJSONValidator: LiftSetJSONValidator?
                    var liftSetDeserializer: LiftSetDeserializer?
                    var workoutListViewController: WorkoutListViewController?
                    var workoutDeleteAgent: WorkoutDeleteAgent?
                    var workoutStoryboardMetadata: WorkoutStoryboardMetadata?
                    
                    beforeEach {
                        timestamper = container.resolve(Timestamper.self)
                        workoutSaveAgent = container.resolve(WorkoutSaveAgent.self)
                        liftSaveAgent = container.resolve(LiftSaveAgent.self)
                        localStorageWorker = container.resolve(LocalStorageWorker.self)
                        workoutSerializer = container.resolve(WorkoutSerializer.self)
                        liftSerializer = container.resolve(LiftSerializer.self)
                        workoutLoadAgent = container.resolve(WorkoutLoadAgent.self)
                        liftLoadAgent = container.resolve(LiftLoadAgent.self)
                        liftHistoryIndexLoader = container.resolve(LiftHistoryIndexLoader.self)
                        workoutDeserializer = container.resolve(WorkoutDeserializer.self)
                        liftSetJSONValidator = container.resolve(LiftSetJSONValidator.self)
                        liftSetDeserializer = container.resolve(LiftSetDeserializer.self)
                        workoutListViewController = storyboard.instantiateViewControllerWithIdentifier("WorkoutListViewController") as? WorkoutListViewController
                        workoutDeleteAgent = container.resolve(WorkoutDeleteAgent.self)
                        workoutStoryboardMetadata = container.resolve(WorkoutStoryboardMetadata.self)
                    }
                    
                    it("can produce a Timestamper") {
                        expect(timestamper).toNot(beNil())
                    }
                    
                    it("can produce a LocalStorageWorker") {
                        expect(localStorageWorker).toNot(beNil())
                    }
                    
                    it("can produce a WorkoutSaveAgent") {
                        expect(workoutSaveAgent).toNot(beNil())
                    }
                    
                    it("can produce a LiftSaveAgent") {
                        expect(liftSaveAgent).toNot(beNil())
                    }
                    
                    it("can produce a WorkoutSerializer") {
                        expect(workoutSerializer).toNot(beNil())
                    }
                    
                    it("can produce a LiftSerializer") {
                        expect(liftSerializer).toNot(beNil())
                    }
                    
                    it("can produce a WorkoutLoadAgent") {
                        expect(workoutLoadAgent).toNot(beNil())
                    }
                    
                    it("can produce a LiftLoadAgent") {
                        expect(liftLoadAgent).toNot(beNil())
                    }
                    
                    it("can produce a LiftHistoryIndexLoader") {
                        expect(liftHistoryIndexLoader).toNot(beNil())
                    }
                    
                    it("can produce a WorkoutDeserializer") {
                        expect(workoutDeserializer).toNot(beNil())
                    }
                    
                    it("can produce a LiftSetJSONValidator") {
                        expect(liftSetJSONValidator).toNot(beNil())
                    }
                    
                    it("can produce a LiftSetDeserializer") {
                        expect(liftSetDeserializer).toNot(beNil())
                    }
                    
                    it("can produce a WorkoutDeleteAgent") {
                        expect(workoutDeleteAgent).toNot(beNil())
                    }
                    
                    it("can produce a WorkoutStoryboardMetadata") {
                        expect(workoutStoryboardMetadata).toNot(beNil())
                    }
                    
                    it("can produce a WorkoutListViewController") {
                        expect(workoutListViewController).toNot(beNil())
                    }
                }
                
                describe("The initial view controller") {
                    var initialViewController: UINavigationController?
                    
                    beforeEach {
                        initialViewController = subject.initialViewController as? UINavigationController
                    }
                    
                    it("is a UINavigationController") {
                        expect(initialViewController).toNot(beNil())
                    }
                    
                    it("contains a WorkoutListViewController") {
                        expect(initialViewController?.topViewController).to(beAnInstanceOf(WorkoutListViewController.self))
                    }
                }
            }
        }
    }
}
