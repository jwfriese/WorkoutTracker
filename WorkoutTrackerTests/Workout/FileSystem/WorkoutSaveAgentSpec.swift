import Quick
import Nimble
@testable import WorkoutTracker

class WorkoutSaveAgentSpec: QuickSpec {
    override func spec() {
        
        class MockWorkoutSerializer: WorkoutSerializer {
            var serializedWorkout: [String : AnyObject] = ["key" : "value"]
            
            override func serialize(workout: Workout) -> [String : AnyObject] {
                return serializedWorkout
            }
        }
        
        class MockLiftSaveAgent: LiftSaveAgent {
            var savedLifts: [Lift] = []
            
            init() {
                super.init(withLiftSerializer: nil, localStorageWorker: nil)
            }
            
            override func save(lift: Lift) {
                savedLifts.append(lift)
            }
        }
        
        class MockLocalStorageWorker: LocalStorageWorker {
            var savedDictionary: [String : AnyObject]?
            
            override private func writeJSONDictionary(dictionary: Dictionary<String, AnyObject>, toFileWithName name: String!,
                                                      createSubdirectories: Bool) {
                savedDictionary = dictionary
            }
        }
        
        describe("WorkoutSaveAgent") {
            var subject: WorkoutSaveAgent!
            var mockWorkoutSerializer: MockWorkoutSerializer!
            var mockLiftSaveAgent: MockLiftSaveAgent!
            var mockLocalStorageWorker: MockLocalStorageWorker!
            
            beforeEach {
                mockWorkoutSerializer = MockWorkoutSerializer()
                mockLiftSaveAgent = MockLiftSaveAgent()
                mockLocalStorageWorker = MockLocalStorageWorker()
                
                subject = WorkoutSaveAgent(withWorkoutSerializer: mockWorkoutSerializer,
                    liftSaveAgent: mockLiftSaveAgent, localStorageWorker: mockLocalStorageWorker)
            }
            
            describe("Its initializer") {
                it("sets its workout serializer") {
                    expect(subject.workoutSerializer).toNot(beNil())
                }
                
                it("sets its lift save agent") {
                    expect(subject.liftSaveAgent).toNot(beNil())
                }
                
                it("sets its local storage worker") {
                    expect(subject.localStorageWorker).toNot(beNil())
                }
            }
            
            describe("Saving a workout") {
                var workout: Workout!
                var liftOne: Lift!
                var liftTwo: Lift!
                var savedFileName: String?
                
                beforeEach {
                    liftOne = Lift(withName: "turtle lift", dataTemplate: .WeightReps)
                    liftTwo = Lift(withName: "turtle press", dataTemplate: .WeightReps)
                    
                    workout = Workout(withName: "turtle workout", timestamp: 1000)
                    workout.addLift(liftOne)
                    workout.addLift(liftTwo)
                    
                    savedFileName = subject.save(workout)
                }
                
                it("serializes the workout and uses the local storage worker to save the data to disk") {
                    if let savedDictionary = mockLocalStorageWorker.savedDictionary {
                        expect(unsafeAddressOf(savedDictionary)).to(equal(unsafeAddressOf(mockWorkoutSerializer.serializedWorkout)))
                        expect(savedFileName).to(equal("Workouts/1000_turtleworkout.json"))
                    } else {
                        fail("Failed to save the workout to disk")
                    }
                }
                
                it("passes each of its lifts to the lift save agent") {
                    expect(mockLiftSaveAgent.savedLifts).to(contain(liftOne))
                    expect(mockLiftSaveAgent.savedLifts).to(contain(liftTwo))
                }
            }
        }
    }
}
