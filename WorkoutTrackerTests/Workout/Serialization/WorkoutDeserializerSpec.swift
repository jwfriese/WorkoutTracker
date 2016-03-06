import Quick
import Nimble
import WorkoutTracker

class WorkoutDeserializerSpec: QuickSpec {
    override func spec() {
        
        class MockLiftDeserializer: LiftDeserializer {
            init() {
                super.init(withLiftSetDeserializer: nil)
            }
            
            override func deserialize(liftDictionary: [String : AnyObject]) -> Lift {
                return Lift(withName: liftDictionary["name"] as! String)
            }
        }
        
        describe("WorkoutDeserializer") {
            var subject: WorkoutDeserializer!
            var mockLiftDeserializer: MockLiftDeserializer!
            
            beforeEach {
                mockLiftDeserializer = MockLiftDeserializer()
                subject = WorkoutDeserializer(withLiftDeserializer: mockLiftDeserializer)
            }
            
            describe("Its initializer") {
                it("sets its lift deserializer") {
                    expect(subject.liftDeserializer).to(beIdenticalTo(mockLiftDeserializer))
                }
            }
            
            describe("Deserializing a dictionary into a workout") {
                var workout: Workout?
                var workoutDictionary: [String : AnyObject]!
                
                beforeEach {
                    workoutDictionary = ["name" : "turtle workout",
                        "timestamp" : 1000,
                        "lifts" : [ ["name" : "lift1"],
                            ["name" : "lift2"],
                            ["name" :  "lift3"]
                        ]
                    ]
                    
                    workout = subject.deserialize(workoutDictionary)
                }
                
                it("deserializes the workout's name") {
                    expect(workout?.name).to(equal("turtle workout"))
                }
                
                it("deserializes the workout's timestamp") {
                    expect(workout?.timestamp).to(equal(1000))
                }
                
                it("uses its lift deserializer to deserialize its list of lifts") {
                    expect(workout?.lifts.count).to(equal(3))
                    if workout?.lifts.count == 3 {
                        expect(workout?.lifts[0].name).to(equal("lift1"))
                        expect(workout?.lifts[1].name).to(equal("lift2"))
                        expect(workout?.lifts[2].name).to(equal("lift3"))
                    } else {
                        fail("Failed to deserialize the workout's list of lifts")
                    }
                }
            }
        }
    }
}
