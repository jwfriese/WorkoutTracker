import Quick
import Nimble
import WorkoutTracker

class LiftHistoryIndexBuilderSpec: QuickSpec {
        override func spec() {
                describe("LiftHistoryIndexBuilder") {
                        var subject: LiftHistoryIndexBuilder!

                        beforeEach {
                                subject = LiftHistoryIndexBuilder()
                        }

                        describe("When building an index of histories for lifts") {
                                var liftHistoryIndex: [String : [UInt]]!
                                var workoutOne: Workout!
                                var workoutTwo: Workout!
                                var workoutThree: Workout!

                                beforeEach {
                                        let liftOneWorkoutOne = Lift(withName: "lift one", dataTemplate: .WeightReps)
                                        let liftTwoWorkoutOne = Lift(withName: "lift two", dataTemplate: .WeightReps)
                                        let liftThreeWorkoutOne = Lift(withName: "lift three", dataTemplate: .WeightReps)
                                        let liftFourWorkoutOne = Lift(withName: "lift four", dataTemplate: .WeightReps)
                                        let liftFiveWorkoutOne = Lift(withName: "lift five", dataTemplate: .WeightReps)
                                        let liftSixWorkoutOne = Lift(withName: "lift six", dataTemplate: .WeightReps)

                                        workoutOne = Workout(withName: "workout one", timestamp: 1000)
                                        workoutOne.addLift(liftOneWorkoutOne)
                                        workoutOne.addLift(liftTwoWorkoutOne)
                                        workoutOne.addLift(liftThreeWorkoutOne)
                                        workoutOne.addLift(liftFourWorkoutOne)
                                        workoutOne.addLift(liftFiveWorkoutOne)
                                        workoutOne.addLift(liftSixWorkoutOne)

                                        let liftOneWorkoutTwo = Lift(withName: "lift one", dataTemplate: .WeightReps)
                                        let liftThreeWorkoutTwo = Lift(withName: "lift three", dataTemplate: .WeightReps)
                                        let liftFiveWorkoutTwo = Lift(withName: "lift five", dataTemplate: .WeightReps)

                                        workoutTwo = Workout(withName: "workout two", timestamp: 2000)
                                        workoutTwo.addLift(liftOneWorkoutTwo)
                                        workoutTwo.addLift(liftThreeWorkoutTwo)
                                        workoutTwo.addLift(liftFiveWorkoutTwo)

                                        let liftTwoWorkoutThree = Lift(withName: "lift two", dataTemplate: .WeightReps)
                                        let liftFourWorkoutThree = Lift(withName: "lift four", dataTemplate: .WeightReps)
                                        let liftSixWorkoutThree = Lift(withName: "lift six", dataTemplate: .WeightReps)

                                        workoutThree = Workout(withName: "workout three", timestamp: 3000)
                                        workoutThree.addLift(liftTwoWorkoutThree)
                                        workoutThree.addLift(liftFourWorkoutThree)
                                        workoutThree.addLift(liftSixWorkoutThree)

                                        liftHistoryIndex = subject.buildIndexFromWorkouts([workoutOne, workoutTwo, workoutThree])
                                }

                                describe("The constructed index") {
                                        it("has an entry for each lift in the collection of workouts") {
                                                expect(liftHistoryIndex.keys.count).to(equal(6))
                                                expect(liftHistoryIndex.keys).to(contain("lift one"))
                                                expect(liftHistoryIndex.keys).to(contain("lift two"))
                                                expect(liftHistoryIndex.keys).to(contain("lift three"))
                                                expect(liftHistoryIndex.keys).to(contain("lift four"))
                                                expect(liftHistoryIndex.keys).to(contain("lift five"))
                                                expect(liftHistoryIndex.keys).to(contain("lift six"))
                                        }

                                        it("maps each lift to a sorted collection of workout identifiers") {
                                                expect(liftHistoryIndex["lift one"]?.count).to(equal(2))
                                                expect(liftHistoryIndex["lift one"]?.first).to(equal(1000))
                                                expect(liftHistoryIndex["lift one"]?.last).to(equal(2000))

                                                expect(liftHistoryIndex["lift four"]?.count).to(equal(2))
                                                expect(liftHistoryIndex["lift four"]?.first).to(equal(1000))
                                                expect(liftHistoryIndex["lift four"]?.last).to(equal(3000))
                                        }
                                }
                        }
                }
        }
}
