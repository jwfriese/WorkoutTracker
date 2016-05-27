import Quick
import Nimble
import Swinject
@testable import WorkoutTracker

class LiftSetDeserializerSpec: QuickSpec {
    override func spec() {
        
        class MockLiftSetJSONValidator: LiftSetJSONValidator {
            let jsonHeightReps = ["height": 10, "reps": 20]
            let jsonWeightReps = ["weight": 100, "reps": 5]
            
            override func validateJSON(jsonData: [String : AnyObject], forDataTemplate dataTemplate: LiftDataTemplate) -> Bool {
                
                if let _ = jsonData["height"] {
                    return dataTemplate == .HeightReps
                }
                
                if let _ = jsonData["weight"] {
                    return dataTemplate == .WeightReps
                }
                
                return false
            }
        }
        
        describe("LiftSetDeserializer") {
            var subject: LiftSetDeserializer!
            var container: Container!
            var mockLiftSetJSONValidator: MockLiftSetJSONValidator!
            
            beforeEach {
                container = Container()
                
                mockLiftSetJSONValidator = MockLiftSetJSONValidator()
                container.register(LiftSetJSONValidator.self) { _ in return mockLiftSetJSONValidator }
                
                LiftSetDeserializer.registerForInjection(container)
                
                subject = container.resolve(LiftSetDeserializer.self)
            }
            
            describe("Its injection") {
                it("sets its LiftSetJSONValidator") {
                    expect(subject.liftSetJSONValidator).to(beIdenticalTo(mockLiftSetJSONValidator))
                }
            }
            
            describe("Deserializing a dictionary into a lift set") {
                var liftSet: LiftSet?
                
                context("When the given JSON defines valid data that matches the given data template") {
                    var matchingJSON: [String : AnyObject]!
                    
                    beforeEach {
                        matchingJSON = mockLiftSetJSONValidator.jsonHeightReps
                        liftSet = subject.deserialize(matchingJSON, usingDataTemplate: .HeightReps)
                    }
                    
                    it("sets the set with the data JSON and data template") {
                        expect(liftSet?.dataTemplate).to(equal(LiftDataTemplate.HeightReps))
                        expect(liftSet?.data["height"] as? Int).to(equal(10))
                        expect(liftSet?.data["reps"] as? Int).to(equal(20))
                    }
                }
                
                context("When the given JSON defines valid data, but it does not match the given template") {
                    var nonmatchingJSON: [String : AnyObject]!
                    
                    beforeEach {
                        nonmatchingJSON = mockLiftSetJSONValidator.jsonWeightReps
                        liftSet = subject.deserialize(nonmatchingJSON, usingDataTemplate: .HeightReps)
                    }
                    
                    it("returns nil") {
                        expect(liftSet).to(beNil())
                    }
                }
            }
        }
    }
}
