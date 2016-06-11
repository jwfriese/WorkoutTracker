import Quick
import Nimble
import Swinject
@testable import WorkoutTracker

class WorkoutDeserializerSpec: QuickSpec {
    override func spec() {
        
        class MockLiftLoadAgent: LiftLoadAgent {
            override func loadLift(withName name: String, fromWorkoutWithIdentifier workoutIdentifier: UInt,
                                            shouldLoadPreviousLift: Bool) -> Lift? {
                return Lift(withName: name, dataTemplate: .WeightReps)
            }
        }
        
        describe("WorkoutDeserializer -") {
            var subject: WorkoutDeserializer!
            var container: Container!
            var mockLiftLoadAgent: MockLiftLoadAgent!
            var mockTimeFormatter: MockTimeFormatter!
            
            beforeEach {
                container = Container()
                
                mockLiftLoadAgent = MockLiftLoadAgent()
                container.register(LiftLoadAgent.self) { _ in return mockLiftLoadAgent }
                
                mockTimeFormatter = MockTimeFormatter()
                container.register(TimeFormatter.self) { _ in return mockTimeFormatter }
                
                WorkoutDeserializer.registerForInjection(container)
                
                subject = container.resolve(WorkoutDeserializer.self)
            }
            
            describe("Its injection") {
                it("sets its LiftLoadAgent") {
                    expect(subject.liftLoadAgent).to(beIdenticalTo(mockLiftLoadAgent))
                }
                
                it("sets its TimeFormatter") {
                    expect(subject.timeFormatter).to(beIdenticalTo(mockTimeFormatter))
                }
            }
            
            describe("Deserializing a dictionary into a workout") {
                var workout: Workout?
                var workoutDictionary: [String : AnyObject]!
                
                beforeEach {
                    mockTimeFormatter.setIntegerTimestampFromSqlTimestamptzString(123456, forInput: "timestamptz string")
                    workoutDictionary = [
                        "name" : "turtle workout",
                        "timestamp" : "timestamptz string",
                        "lifts" : [ "lift1", "lift2", "lift3" ]
                    ]
                    
                    workout = subject.deserialize(workoutDictionary)
                }
                
                it("deserializes the workout's name") {
                    expect(workout?.name).to(equal("turtle workout"))
                }
                
                it("deserializes the workout's timestamp") {
                    expect(workout?.timestamp).to(equal(123456))
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
