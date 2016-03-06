import Quick
import Nimble
import WorkoutTracker

class LiftDeserializerSpec: QuickSpec {
    override func spec() {
        
        class MockLiftSetDeserializer: LiftSetDeserializer {
            override func deserialize(liftSetDictionary: [String : AnyObject]) -> LiftSet {
                return LiftSet(withWeight: liftSetDictionary["weight"] as! Double, reps: 0)
            }
        }
        
        describe("LiftDeserializer") {
            var subject: LiftDeserializer!
            var mockLiftSetDeserializer: MockLiftSetDeserializer!
            
            beforeEach {
                mockLiftSetDeserializer = MockLiftSetDeserializer()
                subject = LiftDeserializer(withLiftSetDeserializer: mockLiftSetDeserializer)
            }
            
            describe("Its initializer") {
                it("sets its lift set deserializer") {
                    expect(subject.liftSetDeserializer).to(beIdenticalTo(mockLiftSetDeserializer))
                }
            }
            
            describe("Deserializing a dictionary into a lift") {
                var lift: Lift?
                var liftDictionary: [String : AnyObject]!
                
                beforeEach {
                    liftDictionary = ["name" : "turtle lift",
                        "sets" : [ ["weight" : 100],
                            ["weight" : 200],
                            ["weight" :  300]
                        ]
                    ]
                    
                    lift = subject.deserialize(liftDictionary)
                }
                
                it("deserializes the lift's name") {
                    expect(lift?.name).to(equal("turtle lift"))
                }
                
                it("uses its lift set deserializer to deserialize its list of sets") {
                    expect(lift?.sets.count).to(equal(3))
                    if lift?.sets.count == 3 {
                        expect(lift?.sets[0].weight).to(equal(100))
                        expect(lift?.sets[1].weight).to(equal(200))
                        expect(lift?.sets[2].weight).to(equal(300))
                    } else {
                        fail("Failed to deserialize the lift's list of sets")
                    }
                }
            }
        }
    }
}
