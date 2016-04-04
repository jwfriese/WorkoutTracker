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
            var liftFileRead: String?
            var liftDictionary: Dictionary<String, AnyObject>?
            
            var previousLiftInstanceFileRead: String?
            var previousLiftInstanceDictionary: Dictionary<String, AnyObject> = [
                "name": "turtle lift",
                "sets": []
            ]
            
            override func readJSONDictionaryFromFile(fileName: String!) -> Dictionary<String, AnyObject>? {
                if fileName == "Lifts/turtle_lift/123456.json" {
                    liftFileRead = fileName
                    return liftDictionary
                } else if fileName == "Lifts/turtle_lift/1234.json" {
                    previousLiftInstanceFileRead = fileName
                    return previousLiftInstanceDictionary
                }
                
                return nil
            }
        }
        
        describe("LiftLoadAgent") {
            var subject: LiftLoadAgent!
            var mockLiftSetDeserializer: MockLiftSetDeserializer!
            var mockLocalStorageWorker: MockLocalStorageWorker!
            
            beforeEach {
                mockLiftSetDeserializer = MockLiftSetDeserializer()
                mockLocalStorageWorker = MockLocalStorageWorker()
                
                subject = LiftLoadAgent(withLiftSetDeserializer: mockLiftSetDeserializer, localStorageWorker: mockLocalStorageWorker)
            }
            
            describe("Its initializer") {
                it("sets its LiftSetDeserializer") {
                    expect(subject.liftSetDeserializer).to(beIdenticalTo(mockLiftSetDeserializer))
                }
                
                it("sets its LocalStorageWorker") {
                    expect(subject.localStorageWorker).to(beIdenticalTo(mockLocalStorageWorker))
                }
            }
            
            describe("Loading a single lift from disk") {
                var lift: Lift?
                
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
                
                sharedExamples("A lift deserializer in all contexts") {
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
                        expect(mockLocalStorageWorker.liftFileRead).to(equal("Lifts/turtle_lift/123456.json"))
                    }
                }
                
                context("The serialized lift includes data about a previous instance's workout") {
                    beforeEach {
                        mockLocalStorageWorker.liftDictionary?["previousLiftWorkoutIdentifier"] = 1234
                        
                        lift = subject.loadLift(withName: "turtle lift", fromWorkoutWithIdentifier: 123456)
                    }
                    
                    it("sets the matching previous lift on the deserialized lift") {
                        expect(lift?.previousInstance?.name).to(equal(lift?.name))
                    }
                    
                    it("uses the local storage worker to load the data from disk") {
                        expect(mockLocalStorageWorker.previousLiftInstanceFileRead).to(equal("Lifts/turtle_lift/1234.json"))
                    }
                }
                
                context("The serialized lift has no data about a previous instance") {
                    beforeEach {
                        lift = subject.loadLift(withName: "turtle lift", fromWorkoutWithIdentifier: 123456)
                    }
                    
                    it("does not set a previous instance on the deserialized lift") {
                        expect(lift?.previousInstance).to(beNil())
                    }
                }
            }
        }
    }
}
