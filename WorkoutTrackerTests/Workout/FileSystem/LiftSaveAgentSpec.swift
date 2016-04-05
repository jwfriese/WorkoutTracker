import Quick
import Nimble
import WorkoutTracker

class LiftSaveAgentSpec: QuickSpec {
    override func spec() {
        class MockLiftSerializer: LiftSerializer {
            var serializedLift: [String : AnyObject] = ["key" : "value"]
            
            init() {
                super.init(withLiftSetSerializer: nil)
            }
            
            override func serialize(lift: Lift) -> [String : AnyObject] {
                return serializedLift
            }
        }
        
        class MockLocalStorageWorker: LocalStorageWorker {
            var savedFileName: String?
            var savedDictionary: [String : AnyObject]?
            
            override private func writeJSONDictionary(dictionary: Dictionary<String, AnyObject>, toFileWithName name: String!, createSubdirectories: Bool) {
                
                savedFileName = name
                savedDictionary = dictionary
            }
        }
        
        describe("LiftSaveAgent") {
            var subject: LiftSaveAgent!
            var mockLiftSerializer: MockLiftSerializer!
            var mockLocalStorageWorker: MockLocalStorageWorker!
            
            beforeEach {
                mockLiftSerializer = MockLiftSerializer()
                mockLocalStorageWorker = MockLocalStorageWorker()
                
                subject = LiftSaveAgent(withLiftSerializer: mockLiftSerializer,
                    localStorageWorker: mockLocalStorageWorker)
            }
            
            describe("Its initializer") {
                it("sets its lift serializer") {
                    expect(subject.liftSerializer).toNot(beNil())
                }
                
                it("sets its local storage worker") {
                    expect(subject.localStorageWorker).toNot(beNil())
                }
            }
            
            describe("Saving a lift") {
                var lift: Lift!
                
                context("When the given lift belongs to a workout") {
                    var workout: Workout!
                    
                    beforeEach {
                        workout = Workout(withName: "turtle workout", timestamp: 12345)
                        lift = Lift(withName: "turtle lift")
                        workout.addLift(lift)
                        
                        subject.save(lift)
                    }
                    
                    it("serializes the lift and uses the local storage worker to save the data to disk") {
                        if let savedDictionary = mockLocalStorageWorker.savedDictionary {
                            expect(unsafeAddressOf(savedDictionary)).to(equal(unsafeAddressOf(mockLiftSerializer.serializedLift)))
                            expect(mockLocalStorageWorker.savedFileName).to(equal("Lifts/turtle_lift/12345.json"))
                        } else {
                            fail("Failed to save the workout to disk")
                        }
                    }
                }
                
                context("When the given lift does not belong to a workout") {
                    beforeEach {
                        lift = Lift(withName: "turtle lift")
                        subject.save(lift)
                    }
                    
                    it("does not attempt to delete anything from disk") {
                        expect(mockLocalStorageWorker.savedFileName).to(beNil())
                    }
                }
            }
        }
    }
}
