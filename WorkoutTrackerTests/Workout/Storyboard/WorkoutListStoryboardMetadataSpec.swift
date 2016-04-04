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
                    var liftSaveAgent: LiftSaveAgent?
                    var localStorageWorker: LocalStorageWorker?
                    var workoutSerializer: WorkoutSerializer?
                    var liftSerializer: LiftSerializer?
                    var liftSetSerializer: LiftSetSerializer?
                    var workoutLoadAgent: WorkoutLoadAgent?
                    var liftLoadAgent: LiftLoadAgent?
                    var workoutDeserializer: WorkoutDeserializer?
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
                        liftSetSerializer = container.resolve(LiftSetSerializer.self)
                        workoutLoadAgent = container.resolve(WorkoutLoadAgent.self)
                        liftLoadAgent = container.resolve(LiftLoadAgent.self)
                        workoutDeserializer = container.resolve(WorkoutDeserializer.self)
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
                    
                    it("can produce a LiftSetSerializer") {
                        expect(liftSetSerializer).toNot(beNil())
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
                    }
                    
                    describe("Its WorkoutDeserializer") {
                        it("is created with a LiftLoadAgent") {
                            expect(workoutDeserializer?.liftLoadAgent).toNot(beNil())
                        }
                    }
                    
                    describe("Its WorkoutDeleteAgent") {
                        it("is created with a LocalStorageWorker") {
                            expect(workoutDeleteAgent?.localStorageWorker).toNot(beNil())
                        }
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
