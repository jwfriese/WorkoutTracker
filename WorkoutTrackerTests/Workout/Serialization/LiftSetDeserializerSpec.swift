import Quick
import Nimble
import WorkoutTracker

class LiftSetDeserializerSpec: QuickSpec {
    override func spec() {

        describe("LiftSetDeserializer") {
            var subject: LiftSetDeserializer!
            
            beforeEach {
                subject = LiftSetDeserializer()
            }
            
            describe("Deserializing a dictionary into a lift set") {
                var set: LiftSet?
                
                beforeEach {
                    let liftSetDictionary = ["weight" : 123.4, "reps" : 10]
                    
                    set = subject.deserialize(liftSetDictionary)
                }
                
                it("deserializes the set's weight") {
                    expect(set?.weight).to(equal(123.4))
                }
                
                it("deserializes the set's reps") {
                    expect(set?.reps).to(equal(10))
                }
            }
        }
    }
}
