import Quick
import Nimble
import WorkoutTracker

class LiftSetSpec: QuickSpec {
        override func spec() {
                describe("LiftSet") {
                        var subject: LiftSet!

                        describe("Its initializer") {
                                beforeEach {
                                        subject = LiftSet(withDataTemplate:.HeightReps, data:["key":"data"])
                                }

                                it("sets the lift set's data template") {
                                        expect(subject.dataTemplate).to(equal(LiftDataTemplate.HeightReps))
                                }

                                it("sets the lift set's data") {
                                        expect(subject.data["key"] as? String).to(equal("data"))
                                }
                        }
                }
        }
}
