import Quick
import Nimble
import WorkoutTracker

class LiftSerializerSpec: QuickSpec {
    class MockLiftSetSerializer: LiftSetSerializer {
        override func serialize(liftSet: LiftSet) -> [String : AnyObject] {
            return ["key" : "value"]
        }
    }
    
    override func spec() {
        describe("LiftSerializer") {
            var subject: LiftSerializer!
            var liftSetSerializer: LiftSetSerializer!
            var lift: Lift!
            var resultJSONDictionary: [String : AnyObject]!
            
            beforeEach {
                liftSetSerializer = MockLiftSetSerializer()
                subject = LiftSerializer(withLiftSetSerializer: liftSetSerializer)
                
                lift = Lift(withName: "turtle lift")
                lift.addSet(LiftSet(withTargetWeight: nil, performedWeight: 100,
                    targetReps: nil, performedReps: 10))
                lift.addSet(LiftSet(withTargetWeight: nil, performedWeight: 200,
                    targetReps: nil, performedReps: 5))
                lift.addSet(LiftSet(withTargetWeight: nil, performedWeight: 300,
                    targetReps: nil, performedReps: 1))
                
                resultJSONDictionary = subject.serialize(lift)
            }
            
            describe("Its initializer") {
                it("sets the lift set serializer") {
                    expect(subject.liftSetSerializer).to(beIdenticalTo(liftSetSerializer))
                }
            }
            
            it("serializes the lift into a dictionary") {
                expect(resultJSONDictionary).toNot(beNil())
            }
            
            it("serializes the lift's name into the result dictionary") {
                if let name = resultJSONDictionary["name"] as? String {
                    expect(name).to(equal("turtle lift"))
                } else {
                    fail("Expected the lift to have its name serialized")
                }
            }
            
            it("serializes the lift's sets into the result dictionary using the lift set serializer") {
                if let sets = resultJSONDictionary["sets"] as? Array<[String : AnyObject]> {
                    expect(sets.count).to(equal(3))
                    expect(sets[0]["key"] as? String).to(equal("value"))
                } else {
                    fail("Expected the lift to have its sets serialized")
                }
            }
        }
    }
}
