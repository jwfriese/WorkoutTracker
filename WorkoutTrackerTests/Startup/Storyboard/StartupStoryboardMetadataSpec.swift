import Quick
import Nimble
import Swinject
import WorkoutTracker

class StartupStoryboardMetadataSpec: QuickSpec {
    override func spec() {
        describe("StartupStoryboardMetadata") {
            var subject: StartupStoryboardMetadata!
            
            beforeEach {
                subject = StartupStoryboardMetadata()
            }
            
            it("has the correct name") {
                expect(subject.name).to(equal("Startup"))
            }
            
            describe("The storyboard created using the metadata") {
                var storyboard: SwinjectStoryboard!
                var container: Container!
                
                beforeEach {
                    container = subject.container
                    storyboard = SwinjectStoryboard.create(name: subject.name, bundle: nil, container: container)
                }
                
                describe("The container") {
                    var migrationAgent: MigrationAgent?
                    var liftHistoryIndexBuilder: LiftHistoryIndexBuilder?
                    var workoutLoadAgent: WorkoutLoadAgent?
                    var liftLoadAgent: LiftLoadAgent?
                    var localStorageWorker: LocalStorageWorker?
                    var liftHistoryIndexLoader: LiftHistoryIndexLoader?
                    var workoutDeserializer: WorkoutDeserializer?
                    var liftSetDeserializer: LiftSetDeserializer?
                    var workoutListStoryboardMetadata: WorkoutListStoryboardMetadata?
                    var startupViewController: StartupViewController?
                    
                    beforeEach {
                        migrationAgent = container.resolve(MigrationAgent.self)
                        liftHistoryIndexBuilder = container.resolve(LiftHistoryIndexBuilder.self)
                        workoutLoadAgent = container.resolve(WorkoutLoadAgent.self)
                        liftLoadAgent = container.resolve(LiftLoadAgent.self)
                        localStorageWorker = container.resolve(LocalStorageWorker.self)
                        liftHistoryIndexLoader = container.resolve(LiftHistoryIndexLoader.self)
                        workoutDeserializer = container.resolve(WorkoutDeserializer.self)
                        liftSetDeserializer = container.resolve(LiftSetDeserializer.self)
                        workoutListStoryboardMetadata = container.resolve(WorkoutListStoryboardMetadata.self)
                        startupViewController = storyboard.instantiateViewControllerWithIdentifier("StartupViewController")
                        as? StartupViewController
                    }
                    
                    it("can produce a MigrationAgent") {
                        expect(migrationAgent).toNot(beNil())
                    }
                    
                    it("can produce a LiftHistoryIndexBuilder") {
                        expect(liftHistoryIndexBuilder).toNot(beNil())
                    }
                    
                    it("can produce a WorkoutLoadAgent") {
                        expect(workoutLoadAgent).toNot(beNil())
                    }
                    
                    it("can produce a LiftLoadAgent") {
                        expect(liftLoadAgent).toNot(beNil())
                    }
                    
                    it("can produce a LocalStorageWorker") {
                        expect(localStorageWorker).toNot(beNil())
                    }
                    
                    it("can produce a LiftHistoryIndexLoader") {
                        expect(liftHistoryIndexLoader).toNot(beNil())
                    }
                    
                    it("can produce a WorkoutDeserializer") {
                        expect(workoutDeserializer).toNot(beNil())
                    }
                    
                    it("can produce a LiftSetDeserializer") {
                        expect(liftSetDeserializer).toNot(beNil())
                    }
                    
                    it("can produce a WorkoutListStoryboardMetadata") {
                        expect(workoutListStoryboardMetadata).toNot(beNil())
                    }
                    
                    it("can produce a StartupViewController") {
                        expect(startupViewController).toNot(beNil())
                    }
                    
                    describe("Its MigrationAgent") {
                        it("is created with a LiftHistoryIndexBuilder") {
                            expect(migrationAgent?.liftHistoryIndexBuilder).toNot(beNil())
                        }
                        
                        it("is created with a WorkoutLoadAgent") {
                            expect(migrationAgent?.workoutLoadAgent).toNot(beNil())
                        }
                        
                        it("is created with LocalStorageWorker") {
                            expect(migrationAgent?.localStorageWorker).toNot(beNil())
                        }
                    }
                    
                    describe("Its WorkoutLoadAgent") {
                        it("is created with a LocalStorageWorker") {
                            expect(workoutLoadAgent?.localStorageWorker).toNot(beNil())
                        }
                        
                        it("is created with a WorkoutDeserializer") {
                            expect(workoutLoadAgent?.workoutDeserializer).toNot(beNil())
                        }
                    }
                    
                    describe("Its LiftLoadAgent") {
                        it("is created with a LiftSetDeserializer") {
                            expect(liftLoadAgent?.liftSetDeserializer).toNot(beNil())
                        }
                        
                        it("is created with a LocalStorageWorker") {
                            expect(liftLoadAgent?.localStorageWorker).toNot(beNil())
                        }
                        
                        it("is created with a LiftHistoryIndexBuilder") {
                            expect(liftLoadAgent?.liftHistoryIndexLoader).toNot(beNil())
                        }
                    }
                    
                    describe("Its LiftHistoryIndexLoader") {
                        it("is created with a LocalStorageWorker") {
                            expect(liftHistoryIndexLoader?.localStorageWorker).toNot(beNil())
                        }
                    }
                    
                    describe("Its WorkoutDeserializer") {
                        it("is created with a LiftLoadAgent") {
                            expect(workoutDeserializer?.liftLoadAgent).toNot(beNil())
                        }
                    }
                    
                    describe("Its StartupViewController") {
                        it("is created with a MigrationAgent") {
                            expect(startupViewController?.migrationAgent).toNot(beNil())
                        }
                        
                        it("is created with a WorkoutListStoryboardMetadata") {
                            expect(startupViewController?.workoutListStoryboardMetadata).toNot(beNil())
                        }
                    }
                }
                
                describe("The initial view controller") {
                    var initialViewController: StartupViewController?
                    
                    beforeEach {
                        initialViewController = subject.initialViewController as? StartupViewController
                    }
                    
                    it("is a StartupViewController") {
                        expect(initialViewController).toNot(beNil())
                    }
                    
                    it("is created with a MigrationAgent") {
                        expect(initialViewController?.migrationAgent).toNot(beNil())
                    }
                    
                    it("is created with a WorkoutListStoryboardMetadata") {
                        expect(initialViewController?.workoutListStoryboardMetadata).toNot(beNil())
                    }
                }
            }
        }
    }
}
