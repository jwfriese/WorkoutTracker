import Quick
import Nimble
import Swinject
@testable import WorkoutTracker

class LiftSaveAgentSpec: QuickSpec {
    override func spec() {
        class MockLiftSerializer: LiftSerializer {
            var serializedLift: [String : AnyObject] = ["key" : "value"]
            
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
            var container: Container!
            var mockLiftSerializer: MockLiftSerializer!
            var mockLocalStorageWorker: MockLocalStorageWorker!
            
            beforeEach {
                container = Container()
                
                mockLiftSerializer = MockLiftSerializer()
                container.register(LiftSerializer.self) { _ in return mockLiftSerializer }
                
                mockLocalStorageWorker = MockLocalStorageWorker()
                container.register(LocalStorageWorker.self) { _ in return mockLocalStorageWorker }
                
                LiftSaveAgent.registerForInjection(container)
                
                subject = container.resolve(LiftSaveAgent.self)
            }
            
            describe("Its injection") {
                it("sets its lift serializer") {
                    expect(subject.liftSerializer).to(beIdenticalTo(mockLiftSerializer))
                }
                
                it("sets its local storage worker") {
                    expect(subject.localStorageWorker).to(beIdenticalTo(mockLocalStorageWorker))
                }
            }
            
            describe("Saving a lift") {
                var lift: Lift!
                
                context("When the given lift belongs to a workout") {
                    var workout: Workout!
                    
                    beforeEach {
                        workout = Workout(withName: "turtle workout", timestamp: 12345)
                        lift = Lift(withName: "turtle lift", dataTemplate: .WeightReps)
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
                        lift = Lift(withName: "turtle lift", dataTemplate: .WeightReps)
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
