import Quick
import Nimble
import WorkoutTracker

class LiftSetSerializerSpec: QuickSpec {
    override func spec() {
        describe("LiftSetSerializer") {
            var subject: LiftSetSerializer!
            var liftSet: LiftSet!
            var resultJSONDictionary: [String : AnyObject]!
            
            beforeEach {
                liftSet = LiftSet(withWeight: 135.5, reps: 10)
                subject = LiftSetSerializer()
                
                resultJSONDictionary = subject.serialize(liftSet)
            }
            
            it("serializes a lift set into JSON dictionary") {
                expect(resultJSONDictionary).toNot(beNil())
                
                if let weight = resultJSONDictionary["weight"] as? Double {
                    expect(weight).to(equal(135.5))
                } else {
                    fail("Expected the set to have its weight serialized")
                }
                
                if let reps = resultJSONDictionary["reps"] as? Int {
                    expect(reps).to(equal(10))
                } else {
                    fail("Expected the set to have its reps serialized")
                }
            }
        }
    }
}
