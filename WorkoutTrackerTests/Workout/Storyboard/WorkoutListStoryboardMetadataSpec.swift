import Quick
import Nimble
import Swinject
import WorkoutTracker

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
                    var localStorageWorker: LocalStorageWorker?
                    var workoutSerializer: WorkoutSerializer?
                    var liftSerializer: LiftSerializer?
                    var liftSetSerializer: LiftSetSerializer?
                    var workoutLoadAgent: WorkoutLoadAgent?
                    var workoutDeserializer: WorkoutDeserializer?
                    var liftDeserializer: LiftDeserializer?
                    var liftSetDeserializer: LiftSetDeserializer?
                    var workoutListViewController: WorkoutListViewController?
                    var workoutDeleteAgent: WorkoutDeleteAgent?
                    var workoutStoryboardMetadata: WorkoutStoryboardMetadata?
                    
                    beforeEach {
                        timestamper = container.resolve(Timestamper.self)
                        workoutSaveAgent = container.resolve(WorkoutSaveAgent.self)
                        localStorageWorker = container.resolve(LocalStorageWorker.self)
                        workoutSerializer = container.resolve(WorkoutSerializer.self)
                        liftSerializer = container.resolve(LiftSerializer.self)
                        liftSetSerializer = container.resolve(LiftSetSerializer.self)
                        workoutLoadAgent = container.resolve(WorkoutLoadAgent.self)
                        workoutDeserializer = container.resolve(WorkoutDeserializer.self)
                        liftDeserializer = container.resolve(LiftDeserializer.self)
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
                    
                    it("can produce a WorkoutSerializer") {
                        expect(workoutSerializer).toNot(beNil())
                    }
                    
                    it("can produce a LiftSerializer") {
                        expect(liftSerializer).toNot(beNil())
                    }
                    
                    it("can produce a LiftSetSerializer") {
                        expect(liftSetSerializer).toNot(beNil())
                    }
                    
                    it("can produce a WorkoutLoadAgent") {
                        expect(workoutLoadAgent).toNot(beNil())
                    }
                    
                    it("can produce a WorkoutDeserializer") {
                        expect(workoutDeserializer).toNot(beNil())
                    }
                    
                    it("can produce a LiftDeserializer") {
                        expect(liftDeserializer).toNot(beNil())
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
                    
                    describe("Its WorkoutListViewController") {
                        it("can be created") {
                            expect(workoutListViewController).toNot(beNil())
                        }
                        
                        it("is created with a Timestamper") {
                            expect(workoutListViewController?.timestamper).toNot(beNil())
                        }
                        
                        it("is created with a WorkoutSaveAgent") {
                            expect(workoutListViewController?.workoutSaveAgent).toNot(beNil())
                        }
                        
                        it("is created with a WorkoutLoadAgent") {
                            expect(workoutListViewController?.workoutLoadAgent).toNot(beNil())
                        }
                        
                        it("is created with a WorkoutDeleteAgent") {
                            expect(workoutListViewController?.workoutDeleteAgent).toNot(beNil())
                        }
                        
                        it("is created with a WorkoutStoryboardMetadata") {
                            expect(workoutListViewController?.workoutStoryboardMetadata).toNot(beNil())
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
                    
                    describe("Its WorkoutLoadAgent") {
                        it("is created with a LocalStorageWorker") {
                            expect(workoutLoadAgent?.localStorageWorker).toNot(beNil())
                        }
                        
                        it("is created with a WorkoutDeserializer") {
                            expect(workoutLoadAgent?.workoutDeserializer).toNot(beNil())
                        }
                    }
                    
                    describe("Its WorkoutDeserializer") {
                        it("is created with a LiftDeserializer") {
                            expect(workoutDeserializer?.liftDeserializer).toNot(beNil())
                        }
                    }
                    
                    describe("Its LiftDeserializer") {
                        it("is created with a LiftSetDeserializer") {
                            expect(liftDeserializer?.liftSetDeserializer).toNot(beNil())
                        }
                    }
                    
                    describe("Its WorkoutDeleteAgent") {
                        it("is created with a LocalStorageWorker") {
                            expect(workoutDeleteAgent?.localStorageWorker).toNot(beNil())
                        }
                    }
                }
                
                describe("The initial view controller") {
                    var initialViewController: WorkoutListViewController?
                    
                    beforeEach {
                        initialViewController = subject.initialViewController as? WorkoutListViewController
                    }
                    
                    it("is a WorkoutListViewController") {
                        expect(initialViewController).toNot(beNil())
                    }
                    
                    it("is created with a Timestamper") {
                        expect(initialViewController?.timestamper).toNot(beNil())
                    }
                    
                    it("is created with a WorkoutSaveAgent") {
                        expect(initialViewController?.workoutSaveAgent).toNot(beNil())
                    }
                    
                    it("is created with a WorkoutLoadAgent") {
                        expect(initialViewController?.workoutLoadAgent).toNot(beNil())
                    }
                    
                    it("is created with a WorkoutDeleteAgent") {
                        expect(initialViewController?.workoutDeleteAgent).toNot(beNil())
                    }
                    
                    it("is created with a WorkoutStoryboardMetadata") {
                        expect(initialViewController?.workoutStoryboardMetadata).toNot(beNil())
                    }
                }
            }
        }
    }
}
