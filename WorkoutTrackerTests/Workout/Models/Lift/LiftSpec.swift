import Quick
import Nimble
import WorkoutTracker

class LiftSpec: QuickSpec {
        override func spec() {
                describe("Lift") {
                        var subject: Lift!

                        describe("Its initializer") {
                                beforeEach {
                                        subject = Lift(withName:"turtle magic", dataTemplate: .TimeInSeconds)
                                }

                                it("sets the name of the lift") {
                                        expect(subject.name).to(equal("turtle magic"))
                                }

                                it("sets the data template of the lift") {
                                        expect(subject.dataTemplate).to(equal(LiftDataTemplate.TimeInSeconds))
                                }
                        }

                        describe("Adding a set to the lift") {
                                var set: LiftSet!

                                beforeEach {
                                        set = LiftSet(withDataTemplate: .WeightReps, data: ["weight": 100])
                                        subject.addSet(set)
                                }

                                it("appends the set to the lift's list of sets") {
                                        expect(subject.sets.count).to(equal(1))
                                        expect(subject.sets[0]).to(beIdenticalTo(set))
                                }

                                it("associates this lift with the added set") {
                                        expect(subject.sets[0].lift).to(beIdenticalTo(subject))
                                }
                        }

                        describe("Identity of a lift") {
                                var liftOne: Lift!
                                var liftTwo: Lift!
                                var liftThree: Lift!
                                var liftFour: Lift!

                                beforeEach {
                                        liftOne = Lift(withName: "turtle lift", dataTemplate: .HeightReps)
                                        liftTwo = Lift(withName: "super turtle lift", dataTemplate: .WeightTimeInSeconds)
                                        liftThree = Lift(withName: "turtle lift", dataTemplate: .HeightReps)
                                        liftFour = Lift(withName: "turtle lift", dataTemplate: .WeightReps)
                                }

                                it("is only the same as another lift if the two have the same name and same data template") {
                                        expect(liftOne.isSame(liftTwo)).to(beFalse())
                                        expect(liftOne.isSame(liftThree)).to(beTrue())
                                        expect(liftOne.isSame(liftFour)).to(beFalse())
                                }
                        }
                }
        }
}
