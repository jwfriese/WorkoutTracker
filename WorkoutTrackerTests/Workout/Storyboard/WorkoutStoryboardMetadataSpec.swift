import Quick
import Nimble
import Swinject
@testable import WorkoutTracker

class WorkoutStoryboardMetadataSpec: QuickSpec {
    override func spec() {
        describe("WorkoutStoryboardMetadata") {
            var subject: WorkoutStoryboardMetadata!
            
            beforeEach {
                subject = WorkoutStoryboardMetadata()
            }
            
            it("has the correct name") {
                expect(subject.name).to(equal("Workout"))
            }
            
            describe("The storyboard created using the metadata") {
                var storyboard: SwinjectStoryboard!
                var container: Container!
                
                beforeEach {
                    container = subject.container
                    storyboard = SwinjectStoryboard.create(name: subject.name, bundle: nil, container: container)
                }
                
                describe("The container") {
                    var workoutSaveAgent: WorkoutSaveAgent?
                    var liftSaveAgent: LiftSaveAgent?
                    var localStorageWorker: LocalStorageWorker?
                    var workoutSerializer: WorkoutSerializer?
                    var liftSerializer: LiftSerializer?
                    var liftCreator: LiftCreator?
                    var liftHistoryIndexLoader: LiftHistoryIndexLoader?
                    var workoutLoadAgent: WorkoutLoadAgent?
                    var liftLoadAgent: LiftLoadAgent?
                    var workoutDeserializer: WorkoutDeserializer?
                    var liftSetJSONValidator: LiftSetJSONValidator?
                    var liftSetDeserializer: LiftSetDeserializer?
                    var liftDeleteAgent: LiftDeleteAgent?
                    var liftTableHeaderViewProvider: LiftTableHeaderViewProvider?
                    var liftSetEditFormControllerFactory: LiftSetEditFormControllerFactory?
                    var workoutViewController: WorkoutViewController?
                    var liftViewController: LiftViewController?
                    var liftEntryFormViewController: LiftEntryFormViewController?
                    var setEditModalViewController: SetEditModalViewController?
                    
                    beforeEach {
                        workoutSaveAgent = container.resolve(WorkoutSaveAgent.self)
                        liftSaveAgent = container.resolve(LiftSaveAgent.self)
                        localStorageWorker = container.resolve(LocalStorageWorker.self)
                        workoutSerializer = container.resolve(WorkoutSerializer.self)
                        liftSerializer = container.resolve(LiftSerializer.self)
                        liftCreator = container.resolve(LiftCreator.self)
                        liftHistoryIndexLoader = container.resolve(LiftHistoryIndexLoader.self)
                        workoutLoadAgent = container.resolve(WorkoutLoadAgent.self)
                        liftLoadAgent = container.resolve(LiftLoadAgent.self)
                        workoutDeserializer = container.resolve(WorkoutDeserializer.self)
                        liftSetJSONValidator = container.resolve(LiftSetJSONValidator.self)
                        liftSetDeserializer = container.resolve(LiftSetDeserializer.self)
                        liftDeleteAgent = container.resolve(LiftDeleteAgent.self)
                        liftTableHeaderViewProvider = container.resolve(LiftTableHeaderViewProvider.self)
                        liftSetEditFormControllerFactory = container.resolve(LiftSetEditFormControllerFactory.self)
                        
                        workoutViewController = storyboard.instantiateViewControllerWithIdentifier("WorkoutViewController") as? WorkoutViewController
                        liftViewController = storyboard.instantiateViewControllerWithIdentifier("LiftViewController") as? LiftViewController
                        liftEntryFormViewController = storyboard.instantiateViewControllerWithIdentifier("LiftEntryFormViewController") as? LiftEntryFormViewController
                        setEditModalViewController = storyboard.instantiateViewControllerWithIdentifier("SetEditModalViewController") as? SetEditModalViewController
                    }
                    
                    it("can produce a WorkoutSaveAgent") {
                        expect(workoutSaveAgent).toNot(beNil())
                    }
                    
                    it("can produce a LiftSaveAgent") {
                        expect(liftSaveAgent).toNot(beNil())
                    }
                    
                    it("can produce a LocalStorageWorker") {
                        expect(localStorageWorker).toNot(beNil())
                    }
                    
                    it("can produce a WorkoutSerializer") {
                        expect(workoutSerializer).toNot(beNil())
                    }
                    
                    it("can produce a LiftSerializer") {
                        expect(liftSerializer).toNot(beNil())
                    }
                    
                    it("can produce a LiftCreator") {
                        expect(liftCreator).toNot(beNil())
                    }
                    
                    it("can produce a LiftHistoryIndexLoader") {
                        expect(liftHistoryIndexLoader).toNot(beNil())
                    }
                    
                    it("can produce a WorkoutLoadAgent") {
                        expect(workoutLoadAgent).toNot(beNil())
                    }
                    
                    it("can produce a LiftLoadAgent") {
                        expect(liftLoadAgent).toNot(beNil())
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
                    
                    it("can produce a LiftDeleteAgent") {
                        expect(liftDeleteAgent).toNot(beNil())
                    }
                    
                    it("can produce a LiftTableHeaderViewProvider") {
                        expect(liftTableHeaderViewProvider).toNot(beNil())
                    }
                    
                    it("can produce a LiftSetEditFormControllerFactory") {
                        expect(liftSetEditFormControllerFactory).toNot(beNil())
                    }
                    
                    it("can produce a WorkoutViewController") {
                        expect(workoutViewController).toNot(beNil())
                    }
                    
                    it("can produce a SetEditModalViewController") {
                        expect(setEditModalViewController).toNot(beNil())
                    }
                    
                    it("can produce a LiftViewController") {
                        expect(liftViewController).toNot(beNil())
                    }
                    
                    it("can produce a LiftEntryFormViewController") {
                        expect(liftEntryFormViewController).toNot(beNil())
                    }
                }
                
                describe("The initial view controller") {
                    var initialViewController: WorkoutViewController?
                    
                    beforeEach {
                        initialViewController = subject.initialViewController as? WorkoutViewController
                    }
                    
                    it("is a WorkoutViewController") {
                        expect(initialViewController).toNot(beNil())
                    }
                }
            }
        }
    }
}
