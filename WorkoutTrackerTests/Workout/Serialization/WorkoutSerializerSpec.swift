import Quick
import Nimble
import WorkoutTracker

class WorkoutSerializerSpec: QuickSpec {
    class MockLiftSerializer: LiftSerializer {
        override func serialize(lift: Lift) -> [String : AnyObject] {
            return ["key" : "value"]
        }
    }
    
    override func spec() {
        describe("WorkoutSerializer") {
            var subject: WorkoutSerializer!
            var liftSerializer: MockLiftSerializer!
            var workout: Workout!
            var resultJSONDictionary: [String : AnyObject]!
            
            beforeEach {
                liftSerializer = MockLiftSerializer(withLiftSetSerializer: LiftSetSerializer())
                subject = WorkoutSerializer(withLiftSerializer: liftSerializer)
                
                workout = Workout(withName: "turtle workout", timestamp: 1000)
                workout.addLift(Lift(withName: "turtle lift 1"))
                workout.addLift(Lift(withName: "turtle lift 2"))
                workout.addLift(Lift(withName: "turtle lift 3"))
                
                resultJSONDictionary = subject.serialize(workout)
            }
            
            describe("Its initializer") {
                it("sets its lift serializer") {
                    expect(subject.liftSerializer).to(beIdenticalTo(liftSerializer))
                }
            }
            
            it("serializes a workout into a dictionary") {
                expect(resultJSONDictionary).toNot(beNil())
                
                if let timestamp = resultJSONDictionary!["timestamp"] as? UInt {
                    expect(timestamp).to(equal(1000))
                }
            }
            
            it("serializes the workout's name into the result dictionary") {
                if let name = resultJSONDictionary!["name"] as? String {
                    expect(name).to(equal("turtle workout"))
                } else {
                    fail("Expected the workout to have its name serialized")
                }
            }
            
            it("serializes the workout's lifts into the result dictionary using the lift serializer") {
                if let lifts = resultJSONDictionary!["lifts"] as? Array<[String : AnyObject]> {
                    expect(lifts.count).to(equal(3))
                    expect(lifts[0]["key"] as? String).to(equal("value"))
                } else {
                    fail("Expected the workout to have its lifts serialized")
                }
            }
        }
    }
}
