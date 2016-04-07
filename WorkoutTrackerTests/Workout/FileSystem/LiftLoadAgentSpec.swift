import Quick
import Nimble
import WorkoutTracker

class LiftLoadAgentSpec: QuickSpec {
    override func spec() {
        
        class MockLiftSetDeserializer: LiftSetDeserializer {
            override func deserialize(liftSetDictionary: [String : AnyObject]) -> LiftSet {
                let weight = liftSetDictionary["weight"] as! Double
                return LiftSet(withTargetWeight: nil, performedWeight: weight,
                               targetReps: nil, performedReps: 0)
            }
        }
        
        class MockLocalStorageWorker: LocalStorageWorker {
            var liftFilesRead: [String] = []
            
            var liftDictionary: Dictionary<String, AnyObject>?
            var previousLiftInstanceDictionary: Dictionary<String, AnyObject> = [
                "name": "turtle lift",
                "sets": [],
            ]
            
            override func readJSONDictionaryFromFile(fileName: String!) -> Dictionary<String, AnyObject>? {
                liftFilesRead.append(fileName)
                
                if fileName == "Lifts/turtle_lift/123456.json" {
                    return liftDictionary
                } else if fileName == "Lifts/turtle_lift/1234.json" {
                    return previousLiftInstanceDictionary
                } else if fileName == "Lifts/turtle_lift/12.json" {
                    return [
                        "name": "turtle lift",
                        "sets": []
                    ]
                }
                
                return nil
            }
        }
        
        class MockLiftHistoryIndexLoader: LiftHistoryIndexLoader {
            var index: [String : [UInt]] = [String : [UInt]]()
            
            init() {
                super.init(withLocalStorageWorker: nil)
            }
            
            override private func load() -> [String : [UInt]] {
                return index
            }
        }
        
        describe("LiftLoadAgent") {
            var subject: LiftLoadAgent!
            var mockLiftSetDeserializer: MockLiftSetDeserializer!
            var mockLocalStorageWorker: MockLocalStorageWorker!
            var mockLiftHistoryIndexLoader: MockLiftHistoryIndexLoader!
            
            beforeEach {
                mockLiftSetDeserializer = MockLiftSetDeserializer()
                mockLocalStorageWorker = MockLocalStorageWorker()
                mockLiftHistoryIndexLoader = MockLiftHistoryIndexLoader()
                
                subject = LiftLoadAgent(withLiftSetDeserializer: mockLiftSetDeserializer, localStorageWorker: mockLocalStorageWorker, liftHistoryIndexLoader: mockLiftHistoryIndexLoader)
            }
            
            describe("Its initializer") {
                it("sets its LiftSetDeserializer") {
                    expect(subject.liftSetDeserializer).to(beIdenticalTo(mockLiftSetDeserializer))
                }
                
                it("sets its LocalStorageWorker") {
                    expect(subject.localStorageWorker).to(beIdenticalTo(mockLocalStorageWorker))
                }
                
                it("sets its LiftHistoryIndexLoader") {
                    expect(subject.liftHistoryIndexLoader).to(beIdenticalTo(mockLiftHistoryIndexLoader))
                }
            }
            
            describe("Loading a lift from disk") {
                var lift: Lift?
                
                beforeEach {
                    mockLocalStorageWorker.liftFilesRead.removeAll()
                }
                
                sharedExamples("A lift load agent in all contexts") {
                    it("deserializes the lift's name") {
                        expect(lift?.name).to(equal("turtle lift"))
                    }
                    
                    it("uses its lift set deserializer to deserialize its list of sets") {
                        expect(lift?.sets.count).to(equal(3))
                        if lift?.sets.count == 3 {
                            expect(lift?.sets[0].performedWeight).to(equal(100))
                            expect(lift?.sets[1].performedWeight).to(equal(200))
                            expect(lift?.sets[2].performedWeight).to(equal(300))
                        } else {
                            fail("Failed to deserialize the lift's list of sets")
                        }
                    }
                    
                    it("uses the local storage worker to load the data from disk") {
                        expect(mockLocalStorageWorker.liftFilesRead).to(contain("Lifts/turtle_lift/123456.json"))
                    }
                }
                
                sharedExamples("A lift load agent that loaded a previous lift") {
                    it("populates the loaded lift with a previous instance") {
                        expect(lift?.previousInstance).toNot(beNil())
                    }
                    
                    it("sets the matching previous lift on the deserialized lift") {
                        expect(lift?.previousInstance?.name).to(equal(lift?.name))
                    }
                    
                    it("uses the local storage worker to load the data from disk") {
                        expect(mockLocalStorageWorker.liftFilesRead).to(contain("Lifts/turtle_lift/1234.json"))
                    }
                }
                
                sharedExamples("A lift load agent that did not load a previous lift") {
                    it("does not set a previous instance on the deserialized lift") {
                        expect(lift?.previousInstance).to(beNil())
                    }
                    
                    it("did not attempt to load the previous instance from disk") {
                        expect(mockLocalStorageWorker.liftFilesRead).toNot(contain("Lifts/turtle_lift/1234.json"))
                    }
                }
                
                beforeEach {
                    mockLocalStorageWorker.liftDictionary = [
                        "name" : "turtle lift",
                        "sets" : [
                            ["weight": 100],
                            ["weight": 200],
                            ["weight": 300]
                        ]
                    ]
                }
                
                context("When told to also load a previous instance") {
                    context("When the lift history index contains data about a previous instance") {
                        beforeEach {
                            mockLiftHistoryIndexLoader.index = ["turtle lift" : [12, 1234]]
                            
                            lift = subject.loadLift(withName: "turtle lift", fromWorkoutWithIdentifier: 123456, shouldLoadPreviousLift: true)
                        }
                        
                        itBehavesLike("A lift load agent in all contexts")
                        itBehavesLike("A lift load agent that loaded a previous lift")
                    }
                    
                    context("When the lift history index does not contain data about a previous instance") {
                        beforeEach {
                            mockLiftHistoryIndexLoader.index = [String : [UInt]]()
                            
                            lift = subject.loadLift(withName: "turtle lift", fromWorkoutWithIdentifier: 123456, shouldLoadPreviousLift: true)
                        }

                        itBehavesLike("A lift load agent in all contexts")
                        itBehavesLike("A lift load agent that did not load a previous lift")
                    }
                }
                
                context("When not told to load previous instance") {
                    beforeEach {
                        lift = subject.loadLift(withName: "turtle lift", fromWorkoutWithIdentifier: 123456, shouldLoadPreviousLift: false)
                    }
                    
                    itBehavesLike("A lift load agent in all contexts")
                    itBehavesLike("A lift load agent that did not load a previous lift")
                }
            }
            
            describe("Loading the latest lift with a certain name from disk") {
                var lift: Lift?
                
                context("When there is no lift with the given name on disk") {
                    beforeEach {
                        lift = subject.loadLatestLiftWithName("turtle press")
                    }
                    
                    it("returns nil") {
                        expect(lift).to(beNil())
                    }
                }
                
                context("When there are lifts with the given name on disk") {
                    beforeEach {
                        mockLiftHistoryIndexLoader.index = ["turtle lift" : [12, 1234]]
                        lift = subject.loadLatestLiftWithName("turtle lift")
                    }
                    
                    it("loads the latest such lift") {
                        expect(lift).toNot(beNil())
                        expect(lift?.name).to(equal("turtle lift"))
                    }
                    
                    it("loads the lift from disk") {
                        expect(mockLocalStorageWorker.liftFilesRead).to(contain("Lifts/turtle_lift/1234.json"))
                    }
                    
                    it("loads the previous instance from disk") {
                        expect(lift?.previousInstance).toNot(beNil())
                        expect(mockLocalStorageWorker.liftFilesRead).to(contain("Lifts/turtle_lift/12.json"))
                    }
                }
            }
        }
    }
}
