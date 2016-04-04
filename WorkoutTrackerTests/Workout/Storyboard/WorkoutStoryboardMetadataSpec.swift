import Quick
import Nimble
import Swinject
import WorkoutTracker

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
                    var liftSetSerializer: LiftSetSerializer?
                    var liftCreator: LiftCreator?
                    var liftHistoryIndexLoader: LiftHistoryIndexLoader?
                    var workoutLoadAgent: WorkoutLoadAgent?
                    var liftLoadAgent: LiftLoadAgent?
                    var workoutDeserializer: WorkoutDeserializer?
                    var liftSetDeserializer: LiftSetDeserializer?
                    var workoutViewController: WorkoutViewController?
                    var liftViewController: LiftViewController?
                    
                    beforeEach {
                        workoutSaveAgent = container.resolve(WorkoutSaveAgent.self)
                        liftSaveAgent = container.resolve(LiftSaveAgent.self)
                        localStorageWorker = container.resolve(LocalStorageWorker.self)
                        workoutSerializer = container.resolve(WorkoutSerializer.self)
                        liftSerializer = container.resolve(LiftSerializer.self)
                        liftSetSerializer = container.resolve(LiftSetSerializer.self)
                        liftCreator = container.resolve(LiftCreator.self)
                        liftHistoryIndexLoader = container.resolve(LiftHistoryIndexLoader.self)
                        workoutLoadAgent = container.resolve(WorkoutLoadAgent.self)
                        liftLoadAgent = container.resolve(LiftLoadAgent.self)
                        workoutDeserializer = container.resolve(WorkoutDeserializer.self)
                        liftSetDeserializer = container.resolve(LiftSetDeserializer.self)
                        workoutViewController = storyboard.instantiateViewControllerWithIdentifier("WorkoutViewController") as? WorkoutViewController
                        liftViewController = storyboard.instantiateViewControllerWithIdentifier("LiftViewController") as? LiftViewController
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
                    
                    it("can produce a LiftSetSerializer") {
                        expect(liftSetSerializer).toNot(beNil())
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
                    
                    it("can produce a LiftSetDeserializer") {
                        expect(liftSetDeserializer).toNot(beNil())
                    }
                    
                    describe("Its WorkoutViewController") {
                        it("can be created") {
                            expect(workoutViewController).toNot(beNil())
                        }
                        
                        it("is created with a WorkoutSaveAgent") {
                            expect(workoutViewController?.workoutSaveAgent).toNot(beNil())
                        }
                        
                        it("is created with a LiftCreator") {
                            expect(workoutViewController?.liftCreator).toNot(beNil())
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
                        it("is created with a WorkoutSerializer") {
                            expect(workoutSaveAgent?.workoutSerializer).toNot(beNil())
                        }
                        
                        it("is created with a LiftSaveAgent") {
                            expect(workoutSaveAgent?.liftSaveAgent).toNot(beNil())
                        }
                        
                        it("is created with a LocalStorageWorker") {
                            expect(workoutSaveAgent?.localStorageWorker).toNot(beNil())
                        }
                    }
                    
                    describe("Its LiftSaveAgent") {
                        it("is created with a LiftSerializer") {
                            expect(liftSaveAgent?.liftSerializer).toNot(beNil())
                        }
                        
                        it("is created with a LocalStorageWorker") {
                            expect(liftSaveAgent?.localStorageWorker).toNot(beNil())
                        }
                    }
                    
                    describe("Its LiftSerializer") {
                        it("is created with a LiftSetSerializer") {
                            expect(liftSerializer?.liftSetSerializer).toNot(beNil())
                        }
                    }
                    
                    describe("Its LiftCreator") {
                        it("is created with a LiftHistoryIndexLoader") {
                            expect(liftCreator?.liftHistoryIndexLoader).toNot(beNil())
                        }
                        
                        it("is created with a WorkoutLoadAgent") {
                            expect(liftCreator?.workoutLoadAgent).toNot(beNil())
                        }
                    }
                    
                    describe("Its LiftHistoryIndexLoader") {
                        it("is created with a LocalStorageWorker") {
                            expect(liftHistoryIndexLoader?.localStorageWorker).toNot(beNil())
                        }
                    }
                    
                    describe("Its WorkoutLoadAgent") {
                        it("is created with a WorkoutDeserializer") {
                            expect(workoutLoadAgent?.workoutDeserializer).toNot(beNil())
                        }
                        
                        it("is created with a LocalStorageWorker") {
                            expect(workoutLoadAgent?.localStorageWorker).toNot(beNil())
                        }
                    }
                    
                    describe("Its LiftLoadAgent") {
                        it("is created with a LiftSetDeserializer") {
                            expect(liftLoadAgent?.liftSetDeserializer).toNot(beNil())
                        }
                        
                        it("is created with a LocalStorageWorker") {
                            expect(liftLoadAgent?.localStorageWorker).toNot(beNil())
                        }
                    }
                    
                    describe("Its WorkoutDeserializer") {
                        it("is created with a LiftLoadAgent") {
                            expect(workoutDeserializer?.liftLoadAgent).toNot(beNil())
                        }
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
                    
                    it("is created with a WorkoutSaveAgent") {
                        expect(initialViewController?.workoutSaveAgent).toNot(beNil())
                    }
                }
            }
        }
    }
}
