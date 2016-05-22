import Quick
import Nimble
import WorkoutTracker

class LiftSetJSONValidatorSpec: QuickSpec {
        override func spec() {
                describe("LiftSetJSONValidator") {
                        var subject: LiftSetJSONValidator!

                        beforeEach {
                                subject = LiftSetJSONValidator()
                        }

                        func testData() -> [LiftDataTemplate : [String : AnyObject]] {
                                return [.HeightReps: ["height" : 10, "reps" : 20],
                                                .WeightReps: ["weight" : 100, "reps" : 15],
                                                .TimeInSeconds: ["time": 60],
                                                .WeightTimeInSeconds: ["weight": 50, "time": 120]
                                ]
                        }

                        describe("Validating JSON against a lift data template") {
                                var template: LiftDataTemplate!
                                var json: [String : AnyObject]!

                                context("Height/Reps template") {
                                        beforeEach {
                                                template = .HeightReps
                                        }

                                        context("When the JSON matches") {
                                                beforeEach {
                                                        json = ["height" : 10, "reps" : 20]
                                                }

                                                it("returns true") {
                                                        expect(subject.validateJSON(json, forDataTemplate: template)).to(beTrue())
                                                }
                                        }

                                        context("When the JSON does not match") {
                                                beforeEach {
                                                        json = ["turtle" : 10, "reps" : 20]
                                                }

                                                it("returns false") {
                                                        expect(subject.validateJSON(json, forDataTemplate: template)).to(beFalse())
                                                }
                                        }
                                }

                                context("Weight/Reps template") {
                                        beforeEach {
                                                template = .WeightReps
                                        }

                                        context("When the JSON matches") {
                                                beforeEach {
                                                        json = ["weight" : 50.5, "reps" : 20]
                                                }

                                                it("returns true") {
                                                        expect(subject.validateJSON(json, forDataTemplate: template)).to(beTrue())
                                                }
                                        }

                                        context("When the JSON does not match") {
                                                beforeEach {
                                                        json = ["turtle" : 10, "reps" : "20"]
                                                }

                                                it("returns false") {
                                                        expect(subject.validateJSON(json, forDataTemplate: template)).to(beFalse())
                                                }
                                        }
                                }

                                context("TimeInSeconds template") {
                                        beforeEach {
                                                template = .TimeInSeconds
                                        }

                                        context("When the JSON matches") {
                                                beforeEach {
                                                        json = ["time(sec)" : 15]
                                                }

                                                it("returns true") {
                                                        expect(subject.validateJSON(json, forDataTemplate: template)).to(beTrue())
                                                }
                                        }

                                        context("When the JSON does not match") {
                                                beforeEach {
                                                        json = ["time(µsec)" : 1500000000000000]
                                                }

                                                it("returns false") {
                                                        expect(subject.validateJSON(json, forDataTemplate: template)).to(beFalse())
                                                }
                                        }
                                }

                                context("Weight/TimeInSeconds template") {
                                        beforeEach {
                                                template = .WeightTimeInSeconds
                                        }

                                        context("When the JSON matches") {
                                                beforeEach {
                                                        json = ["weight" : 10, "time(sec)" : 20.9]
                                                }

                                                it("returns true") {
                                                        expect(subject.validateJSON(json, forDataTemplate: template)).to(beTrue())
                                                }
                                        }

                                        context("When the JSON does not match") {
                                                beforeEach {
                                                        json = ["turtle" : 10, "reps" : 20]
                                                }

                                                it("returns false") {
                                                        expect(subject.validateJSON(json, forDataTemplate: template)).to(beFalse())
                                                }
                                        }
                                }
                        }
                }
        }
}
