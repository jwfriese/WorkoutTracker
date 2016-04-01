import Quick
import Nimble
import WorkoutTracker

class LiftDeserializerSpec: QuickSpec {
    override func spec() {
        
        class MockLiftSetDeserializer: LiftSetDeserializer {
            override func deserialize(liftSetDictionary: [String : AnyObject]) -> LiftSet {
                let weight = liftSetDictionary["weight"] as! Double
                return LiftSet(withTargetWeight: nil, performedWeight: weight,
                    targetReps: nil, performedReps: 0)
            }
        }
        
        class MockWorkoutLoadAgent: WorkoutLoadAgent {
            var previousWorkout: Workout?
            let turtlePress = Lift(withName: "turtle press")
            let turtleLift = Lift(withName: "turtle lift")
            let turtleClean = Lift(withName: "turtle clean")
            
            init() {
                super.init(withWorkoutDeserializer: nil, localStorageWorker: nil)
            }
            
            override private func loadWorkout(withIdentifier workoutIdentifier: UInt) -> Workout? {
                previousWorkout = Workout(withName: "turtle workout", timestamp: workoutIdentifier)
                
                previousWorkout?.addLift(turtlePress)
                previousWorkout?.addLift(turtleLift)
                previousWorkout?.addLift(turtleClean)
                
                return previousWorkout
            }
        }
        
        describe("LiftDeserializer") {
            var subject: LiftDeserializer!
            var mockLiftSetDeserializer: MockLiftSetDeserializer!
            var mockWorkoutLoadAgent: MockWorkoutLoadAgent!
            
            beforeEach {
                mockLiftSetDeserializer = MockLiftSetDeserializer()
                mockWorkoutLoadAgent = MockWorkoutLoadAgent()
                subject = LiftDeserializer(withLiftSetDeserializer: mockLiftSetDeserializer)
                subject.workoutLoadAgent = mockWorkoutLoadAgent
            }
            
            describe("Its initializer") {
                it("sets its lift set deserializer") {
                    expect(subject.liftSetDeserializer).to(beIdenticalTo(mockLiftSetDeserializer))
                }
                
                it("sets its WorkoutLoadAgent") {
                    expect(subject.workoutLoadAgent).to(beIdenticalTo(mockWorkoutLoadAgent))
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
                }
                
                sharedExamples("A lift deserializer in all contexts") {
                    it("deserializes the lift's name") {
                        expect(lift?.name).to(equal("turtle lift"))
                    }
                    
                    it("uses its lift set deserializer to deserialize its list of sets") {
                        expect(lift?.sets.count).to(equal(3))
                        if lift?.sets.count == 3 {
                            expect(lift?.sets[0].performedWeight).to(equal(100))
                            expect(lift?.sets[1].performedWeight).to(equal(200))
                            expect(lift?.sets[2].performedWeight).to(equal(300))
                        } else {
                            fail("Failed to deserialize the lift's list of sets")
                        }
                    }
                }
                
                context("The serialized lift includes data about a previous instance's workout") {
                    beforeEach {
                        liftDictionary["previousLiftWorkoutIdentifier"] = 1234
                        
                        lift = subject.deserialize(liftDictionary)
                    }
                    
                    it("sets the matching lift from the workout on the deserialized lift") {
                        expect(lift?.previousInstance).to(beIdenticalTo(mockWorkoutLoadAgent.turtleLift))
                    }
                }
                
                context("The serialized lift has no data about a previous instance") {
                    beforeEach {
                        lift = subject.deserialize(liftDictionary)
                    }
                    
                    it("does not set a previous instance on the deserialized lift") {
                        expect(lift?.previousInstance).to(beNil())
                    }
                }
            }
        }
    }
}
