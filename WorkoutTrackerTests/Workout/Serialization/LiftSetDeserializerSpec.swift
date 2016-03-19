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
                var inputDictionary: Dictionary<String,AnyObject>!
                
                context("When dictionary is populated with all values") {
                    beforeEach {
                        inputDictionary = ["targetWeight" : 234.5, "weight" : 123.4,
                            "targetReps" : 10, "reps" : 9]
                        set = subject.deserialize(inputDictionary)
                    }
                    
                }
                
                context("When dictionary is missing target weight") {
                    beforeEach {
                        inputDictionary = ["weight" : 123.4, "targetReps" : 10, "reps" : 9]
                        set = subject.deserialize(inputDictionary)
                    }
                    
                    it("initializes the lift set's target weight with nil") {
                        expect(set?.targetWeight).to(beNil())
                    }
                    
                    it("initializes the lift set's performed weight with the data value") {
                        expect(set?.performedWeight).to(equal(123.4))
                    }
                    
                    it("initializes the lift set's target reps with the data value") {
                        expect(set?.targetReps).to(equal(10))
                    }
                    
                    it("initializes the lift set's performed reps with the data value") {
                        expect(set?.performedReps).to(equal(9))
                    }
                }
                
                context("When dictionary is missing target reps") {
                    beforeEach {
                        inputDictionary = ["targetWeight" : 234.5, "weight" : 123.4, "reps" : 9]
                        set = subject.deserialize(inputDictionary)
                    }
                    
                    it("initializes the lift set's target weight with the data value") {
                        expect(set?.targetWeight).to(equal(234.5))
                    }
                    
                    it("initializes the lift set's performed weight with the data value") {
                        expect(set?.performedWeight).to(equal(123.4))
                    }
                    
                    it("initializes the lift set's target reps with nil") {
                        expect(set?.targetReps).to(beNil())
                    }
                    
                    it("initializes the lift set's performed reps with the data value") {
                        expect(set?.performedReps).to(equal(9))
                    }
                }
                
                context("When dictionary is missing weight") {
                    beforeEach {
                        inputDictionary = ["targetWeight" : 234.5, "targetReps" : 10, "reps" : 9]
                        set = subject.deserialize(inputDictionary)
                    }
                    
                    it("returns nil") {
                        expect(set).to(beNil())
                    }
                }
                
                context("When dictionary is missing reps") {
                    beforeEach {
                        inputDictionary = ["targetWeight" : 234.5, "weight" : 123.4,
                            "targetReps" : 10]
                        set = subject.deserialize(inputDictionary)
                    }
                    
                    it("returns nil") {
                        expect(set).to(beNil())
                    }
                }
            }
        }
    }
}
