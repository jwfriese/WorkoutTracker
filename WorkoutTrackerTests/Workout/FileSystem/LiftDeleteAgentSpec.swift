import Quick
import Nimble
import Swinject
@testable import WorkoutTracker

class LiftDeleteAgentSpec: QuickSpec {
    override func spec() {
        
        class MockLocalStorageWorker: LocalStorageWorker {
            var deletedFileName: String?
            
            override private func deleteFile(fileName: String!) throws {
                deletedFileName = fileName
            }
        }
        
        describe("LiftDeleteAgent") {
            var subject: LiftDeleteAgent!
            var container: Container!
            var mockLocalStorageWorker: MockLocalStorageWorker!
            
            beforeEach {
                container = Container()
                
                mockLocalStorageWorker = MockLocalStorageWorker()
                container.register(LocalStorageWorker.self) { _ in return mockLocalStorageWorker }
                
                LiftDeleteAgent.registerForInjection(container)
                
                subject = container.resolve(LiftDeleteAgent.self)
            }
            
            describe("Its injection") {
                it("sets the local storage worker") {
                    expect(subject.localStorageWorker).to(beIdenticalTo(mockLocalStorageWorker))
                }
            }
            
            describe("Deleting a lift") {
                var lift: Lift!
                
                context("When the given lift belongs to a workout") {
                    var workout: Workout!
                    
                    beforeEach {
                        workout = Workout(withName: "turtle workout", timestamp: 123456789)
                        lift = Lift(withName: "turtle lift", dataTemplate: .WeightReps)
                        workout.addLift(lift)
                        
                        subject.delete(lift)
                    }
                    
                    it("deletes the file associated with the given lift from disk") {
                        expect(mockLocalStorageWorker.deletedFileName).to(equal("Lifts/turtle_lift/123456789.json"))
                    }
                }
                
                context("When the given lift does not belong to a workout") {
                    beforeEach {
                        lift = Lift(withName: "turtle lift", dataTemplate: .WeightReps)
                        subject.delete(lift)
                    }
                    
                    it("does not attempt to delete anything from disk") {
                        expect(mockLocalStorageWorker.deletedFileName).to(beNil())
                    }
                }
            }
        }
    }
}
