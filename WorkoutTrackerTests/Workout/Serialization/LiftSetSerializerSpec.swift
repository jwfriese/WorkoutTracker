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
                subject = LiftSetSerializer()
            }
            
            context("With a fully formed lift set model") {
                beforeEach {
                    liftSet = LiftSet(withTargetWeight: 345.6, performedWeight: 234.5,
                        targetReps: 20, performedReps: 16)
                    
                    resultJSONDictionary = subject.serialize(liftSet)
                }
                
                it("serializes a lift set into JSON dictionary") {
                    expect(resultJSONDictionary).toNot(beNil())
                }
                
                it("serializes the target weight data") {
                    if let targetWeight = resultJSONDictionary["targetWeight"] as? Double {
                        expect(targetWeight).to(equal(345.6))
                    } else {
                        fail("Expected the set to have its target weight serialized")
                    }
                }
                
                it("serializes the performed weight data") {
                    if let weight = resultJSONDictionary["weight"] as? Double {
                        expect(weight).to(equal(234.5))
                    } else {
                        fail("Expected the set to have its weight serialized")
                    }
                }
                
                it("serializes the target reps data") {
                    if let reps = resultJSONDictionary["targetReps"] as? Int {
                        expect(reps).to(equal(20))
                    } else {
                        fail("Expected the set to have its target reps serialized")
                    }
                }
                
                it("serializes the performed reps data") {
                    if let reps = resultJSONDictionary["reps"] as? Int {
                        expect(reps).to(equal(16))
                    } else {
                        fail("Expected the set to have its reps serialized")
                    }
                }
            }
            
            context("With a lift set model missing a target weight") {
                beforeEach {
                    liftSet = LiftSet(withTargetWeight: nil, performedWeight: 234.5,
                        targetReps: 20, performedReps: 16)
                    
                    resultJSONDictionary = subject.serialize(liftSet)
                }
                
                it("serializes a lift set into JSON dictionary") {
                    expect(resultJSONDictionary).toNot(beNil())
                }
                
                it("does not serialize any target weight data") {
                    if let _ = resultJSONDictionary["targetWeight"] as? Double {
                        fail("Expected the serialized set to have no targetWeight field")
                    }
                }
                
                it("serializes the performed weight data") {
                    if let weight = resultJSONDictionary["weight"] as? Double {
                        expect(weight).to(equal(234.5))
                    } else {
                        fail("Expected the set to have its weight serialized")
                    }
                }
                
                it("serializes the target reps data") {
                    if let reps = resultJSONDictionary["targetReps"] as? Int {
                        expect(reps).to(equal(20))
                    } else {
                        fail("Expected the set to have its target reps serialized")
                    }
                }
                
                it("serializes the performed reps data") {
                    if let reps = resultJSONDictionary["reps"] as? Int {
                        expect(reps).to(equal(16))
                    } else {
                        fail("Expected the set to have its reps serialized")
                    }
                }
            }
            
            context("With a lift set model missing a target reps") {
                beforeEach {
                    liftSet = LiftSet(withTargetWeight: 345.6, performedWeight: 234.5,
                        targetReps: nil, performedReps: 16)
                    
                    resultJSONDictionary = subject.serialize(liftSet)
                }
                
                it("serializes a lift set into JSON dictionary") {
                    expect(resultJSONDictionary).toNot(beNil())
                }
                
                it("serializes the target weight data") {
                    if let targetWeight = resultJSONDictionary["targetWeight"] as? Double {
                        expect(targetWeight).to(equal(345.6))
                    } else {
                        fail("Expected the set to have its target weight serialized")
                    }
                }
                
                it("serializes the performed weight data") {
                    if let weight = resultJSONDictionary["weight"] as? Double {
                        expect(weight).to(equal(234.5))
                    } else {
                        fail("Expected the set to have its weight serialized")
                    }
                }
                
                it("does not serialize any target reps data") {
                    if let _ = resultJSONDictionary["targetReps"] as? Int {
                        fail("Expected the serialized set to have no targetReps field")
                    }
                }
                
                it("serializes the performed reps data") {
                    if let reps = resultJSONDictionary["reps"] as? Int {
                        expect(reps).to(equal(16))
                    } else {
                        fail("Expected the set to have its reps serialized")
                    }
                }
            }
        }
    }
}
