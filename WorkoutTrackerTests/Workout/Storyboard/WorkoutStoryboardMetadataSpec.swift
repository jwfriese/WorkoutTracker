import Quick
import Nimble
import Swinject
import WorkoutTracker

class WorkoutStoryboardMetadataSpec: QuickSpec {
    override func spec() {
        describe("WorkoutStoryboardMetadata") {
            it("has the correct name") {
                expect(WorkoutStoryboardMetadata.name).to(equal("Workout"))
            }
            
            describe("The storyboard created using the metadata") {
                var storyboard: SwinjectStoryboard!
                var container: Container!
                
                beforeEach {
                    container = WorkoutStoryboardMetadata.container
                    storyboard = SwinjectStoryboard.create(name: WorkoutStoryboardMetadata.name, bundle: nil, container: container)
                }
                
                describe("The container") {
                    var workoutSaveAgent: WorkoutSaveAgent?
                    var localStorageWorker: LocalStorageWorker?
                    var workoutSerializer: WorkoutSerializer?
                    var liftSerializer: LiftSerializer?
                    var liftSetSerializer: LiftSetSerializer?
                    var workoutViewController: WorkoutViewController?
                    var liftViewController: LiftViewController?
                    
                    beforeEach {
                        workoutSaveAgent = container.resolve(WorkoutSaveAgent.self)
                        localStorageWorker = container.resolve(LocalStorageWorker.self)
                        workoutSerializer = container.resolve(WorkoutSerializer.self)
                        liftSerializer = container.resolve(LiftSerializer.self)
                        liftSetSerializer = container.resolve(LiftSetSerializer.self)
                        workoutViewController = storyboard.instantiateViewControllerWithIdentifier("WorkoutViewController") as? WorkoutViewController
                        liftViewController = storyboard.instantiateViewControllerWithIdentifier("LiftViewController") as? LiftViewController
                    }
                    
                    it("can produce a WorkoutSaveAgent") {
                        expect(workoutSaveAgent).toNot(beNil())
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
                    
                    it("can produce a LiftSetSerializer") {
                        expect(liftSetSerializer).toNot(beNil())
                    }
                    
                    describe("Its WorkoutViewController") {
                        it("can be created") {
                            expect(workoutViewController).toNot(beNil())
                        }
                        
                        it("is created with a WorkoutSaveAgent") {
                            expect(workoutViewController?.workoutSaveAgent).toNot(beNil())
                        }
                    }
                    
                    describe("Its LiftViewController") {
                        it("can be created") {
                            expect(liftViewController).toNot(beNil())
                        }
                        
                        it("is created with a WorkoutSaveAgent") {
                            expect(liftViewController?.workoutSaveAgent).toNot(beNil())
                        }
                    }
                    
                    describe("Its WorkoutSaveAgent") {
                        it("is created with a LocalStorageWorker") {
                            expect(workoutSaveAgent?.localStorageWorker).toNot(beNil())
                        }
                        
                        it("is created with a WorkoutSerializer") {
                            expect(workoutSaveAgent?.workoutSerializer).toNot(beNil())
                        }
                    }
                    
                    describe("Its WorkoutSerializer") {
                        it("is created with a LiftSerializer") {
                            expect(workoutSerializer?.liftSerializer).toNot(beNil())
                        }
                    }
                    
                    describe("Its LiftSerializer") {
                        it("is created with a LiftSetSerializer") {
                            expect(liftSerializer?.liftSetSerializer).toNot(beNil())
                        }
                    }
                }
            }
        }
    }
}
