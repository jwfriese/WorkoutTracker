import Quick
import Nimble
import Swinject
@testable import WorkoutTracker

class WorkoutSerializerSpec: QuickSpec {
    override func spec() {
        
        describe("WorkoutSerializer -") {
            var subject: WorkoutSerializer!
            var mockTimeFormatter: MockTimeFormatter!
            
            beforeEach {
                let container = Container()
                
                mockTimeFormatter = MockTimeFormatter()
                container.register(TimeFormatter.self) { _ in return mockTimeFormatter }
                
                WorkoutSerializer.registerForInjection(container)
                subject = container.resolve(WorkoutSerializer.self)
            }
            
            describe("Its injection") {
                it("sets its TimeFormatter") {
                    expect(subject.timeFormatter).to(beIdenticalTo(mockTimeFormatter))
                }
            }
            
            describe("Serialization") {
                var workout: Workout!
                var resultJSONDictionary: [String : AnyObject]!
                
                beforeEach {
                    workout = Workout(withName: "turtle workout", timestamp: 1000)
                    workout.addLift(Lift(withName: "turtle lift 1", dataTemplate: .WeightReps))
                    workout.addLift(Lift(withName: "turtle lift 2", dataTemplate: .WeightReps))
                    workout.addLift(Lift(withName: "turtle lift 3", dataTemplate: .WeightReps))
                    
                    mockTimeFormatter.setSqlTimestamptzStringFromIntegerTimestamp("timestamp string", forInput: 1000)
                    
                    resultJSONDictionary = subject.serialize(workout)
                }
                
                it("transforms a workout into a dictionary") {
                    expect(resultJSONDictionary).toNot(beNil())
                }
                
                describe("The dictionary format") {
                    it("serializes the workout's timestamp into the result") {
                        if let timestamp = resultJSONDictionary!["timestamp"] as? String {
                            expect(timestamp).to(equal("timestamp string"))
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
}
