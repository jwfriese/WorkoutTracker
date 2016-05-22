import Quick
import Nimble
@testable import WorkoutTracker

class WorkoutSerializerSpec: QuickSpec {
    override func spec() {
        describe("WorkoutSerializer") {
            var subject: WorkoutSerializer!
            var workout: Workout!
            var resultJSONDictionary: [String : AnyObject]!
            
            beforeEach {
                subject = WorkoutSerializer()
                
                workout = Workout(withName: "turtle workout", timestamp: 1000)
                workout.addLift(Lift(withName: "turtle lift 1", dataTemplate: .WeightReps))
                workout.addLift(Lift(withName: "turtle lift 2", dataTemplate: .WeightReps))
                workout.addLift(Lift(withName: "turtle lift 3", dataTemplate: .WeightReps))
                
                resultJSONDictionary = subject.serialize(workout)
            }
            
            it("serializes a workout into a dictionary") {
                expect(resultJSONDictionary).toNot(beNil())
            }
            
            describe("The dictionary format") {
                it("serializes the workout's timestamp into the result") {
                    if let timestamp = resultJSONDictionary!["timestamp"] as? UInt {
                        expect(timestamp).to(equal(1000))
                    } else {
                        fail("Expected the workout to have its timestamp serialized")
                    }
                }
                
                it("serializes the workout's name into the result dictionary") {
                    if let name = resultJSONDictionary!["name"] as? String {
                        expect(name).to(equal("turtle workout"))
                    } else {
                        fail("Expected the workout to have its name serialized")
                    }
                }
                
                it("serializes the workout's lifts into a list of lift names") {
                    if let lifts = resultJSONDictionary!["lifts"] as? [String] {
                        expect(lifts.count).to(equal(3))
                        expect(lifts[0]).to(equal("turtle lift 1"))
                        expect(lifts[1]).to(equal("turtle lift 2"))
                        expect(lifts[2]).to(equal("turtle lift 3"))
                    } else {
                        fail("Expected the workout to have its lifts serialized")
                    }
                }
            }
        }
    }
}
