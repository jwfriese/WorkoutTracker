import Quick
import Nimble
import WorkoutTracker

class LiftSerializerSpec: QuickSpec {
        override func spec() {
                describe("LiftSerializer") {
                        var subject: LiftSerializer!
                        var lift: Lift!
                        var resultJSONDictionary: [String : AnyObject]!

                        beforeEach {
                                subject = LiftSerializer()

                                lift = Lift(withName: "turtle lift", dataTemplate: .WeightTimeInSeconds)
                                lift.addSet(LiftSet(withDataTemplate: .WeightTimeInSeconds, data: ["data": 1]))
                                lift.addSet(LiftSet(withDataTemplate: .WeightTimeInSeconds, data: ["data": 2]))
                                lift.addSet(LiftSet(withDataTemplate: .WeightTimeInSeconds, data: ["data": 3]))
                        }

                        sharedExamples("A lift serializer in all contexts") {
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

                                it("serializes the lift's data template into the result dictionary") {
                                        if let dataTemplate = resultJSONDictionary["dataTemplate"] as? String {
                                                expect(dataTemplate).to(equal(lift.dataTemplate?.rawValue))
                                        } else {
                                                fail("Expected the lift to have its data template serialized")
                                        }
                                }

                                it("serializes the lift's sets into the result dictionary using the lift set serializer") {
                                        if let sets = resultJSONDictionary["sets"] as? Array<[String : AnyObject]> {
                                                expect(sets.count).to(equal(3))
                                                expect(sets[0]["data"] as? Int).to(equal(1))
                                        } else {
                                                fail("Expected the lift to have its sets serialized")
                                        }
                                }
                        }

                        context("When the lift has a workout") {
                                var owningWorkout: Workout!

                                beforeEach {
                                        owningWorkout = Workout(withName: "turtle workout", timestamp: 1111)
                                        lift.workout = owningWorkout

                                        resultJSONDictionary = subject.serialize(lift)
                                }

                                it("serializes the identifier of the lift's workout") {
                                        if let workoutIdentifier = resultJSONDictionary["workout"] as? UInt {
                                                expect(workoutIdentifier).to(equal(1111))
                                        } else {
                                                fail("Expected the lift to have its workout's identifier serialized")
                                        }
                                }

                                itBehavesLike("A lift serializer in all contexts")
                        }

                        context("When the lift does not have a workout") {
                                beforeEach {
                                        resultJSONDictionary = subject.serialize(lift)
                                }

                                it("does not serialize the identifier of the lift's workout") {
                                        expect(resultJSONDictionary["workout"] as? UInt).to(beNil())
                                }

                                itBehavesLike("A lift serializer in all contexts")
                        }

                        context("When the lift has a previous instance with a workout") {
                                beforeEach {
                                        let previousWorkout = Workout(withName: "previous turtle workout", timestamp: 1234)
                                        let previousLift = Lift(withName: "turtle lift", dataTemplate: .WeightReps)
                                        previousWorkout.addLift(previousLift)

                                        lift.previousInstance = previousLift

                                        resultJSONDictionary = subject.serialize(lift)
                                }

                                itBehavesLike("A lift serializer in all contexts")
                        }

                        context("When the lift has a previous instance with no workout") {
                                beforeEach {
                                        let previousLift = Lift(withName: "turtle lift", dataTemplate: .WeightReps)
                                        lift.previousInstance = previousLift

                                        resultJSONDictionary = subject.serialize(lift)
                                }

                                itBehavesLike("A lift serializer in all contexts")
                        }

                        context("When the lift has no previous instance") {
                                beforeEach {
                                        resultJSONDictionary = subject.serialize(lift)
                                }

                                itBehavesLike("A lift serializer in all contexts")
                        }
                }
        }
}
