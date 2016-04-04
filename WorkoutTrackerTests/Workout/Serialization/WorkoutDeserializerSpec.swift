import Quick
import Nimble
import WorkoutTracker

class WorkoutDeserializerSpec: QuickSpec {
    override func spec() {
        
        class MockLiftLoadAgent: LiftLoadAgent {
            init() {
                super.init(withLiftSetDeserializer: nil, localStorageWorker: nil)
            }
            
            override func loadLift(withName name: String, fromWorkoutWithIdentifier workoutIdentifier: UInt) -> Lift? {
                return Lift(withName: name)
            }
        }
        
        describe("WorkoutDeserializer") {
            var subject: WorkoutDeserializer!
            var mockLiftLoadAgent: MockLiftLoadAgent!
            
            beforeEach {
                mockLiftLoadAgent = MockLiftLoadAgent()
                subject = WorkoutDeserializer(withLiftLoadAgent: mockLiftLoadAgent)
            }
            
            describe("Its initializer") {
                it("sets it lift load agent") {
                    expect(subject.liftLoadAgent).to(beIdenticalTo(mockLiftLoadAgent))
                }
            }
            
            describe("Deserializing a dictionary into a workout") {
                var workout: Workout?
                var workoutDictionary: [String : AnyObject]!
                
                beforeEach {
                    workoutDictionary = [
                        "name" : "turtle workout",
                        "timestamp" : 1000,
                        "lifts" : [ "lift1", "lift2", "lift3" ]
                    ]
                    
                    workout = subject.deserialize(workoutDictionary)
                }
                
                it("deserializes the workout's name") {
                    expect(workout?.name).to(equal("turtle workout"))
                }
                
                it("deserializes the workout's timestamp") {
                    expect(workout?.timestamp).to(equal(1000))
                }
                
                it("uses its lift load agent to load its list of lifts") {
                    expect(workout?.lifts.count).to(equal(3))
                    if workout?.lifts.count == 3 {
                        expect(workout?.lifts[0].name).to(equal("lift1"))
                        expect(workout?.lifts[0].workout).to(beIdenticalTo(workout))
                        
                        expect(workout?.lifts[1].name).to(equal("lift2"))
                        expect(workout?.lifts[1].workout).to(beIdenticalTo(workout))
                        
                        expect(workout?.lifts[2].name).to(equal("lift3"))
                        expect(workout?.lifts[2].workout).to(beIdenticalTo(workout))
                    } else {
                        fail("Failed to deserialize the workout's list of lifts")
                    }
                }
            }
        }
    }
}
