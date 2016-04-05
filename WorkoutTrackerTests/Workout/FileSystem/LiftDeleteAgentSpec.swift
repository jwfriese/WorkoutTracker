import Quick
import Nimble
import WorkoutTracker

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
            var mockLocalStorageWorker: MockLocalStorageWorker!
            
            beforeEach {
                mockLocalStorageWorker = MockLocalStorageWorker()
                subject = LiftDeleteAgent(withLocalStorageWorker: mockLocalStorageWorker)
            }
            
            describe("Its initializer") {
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
                        lift = Lift(withName: "turtle lift")
                        workout.addLift(lift)
                        
                        subject.delete(lift)
                    }
                    
                    it("deletes the file associated with the given lift from disk") {
                        expect(mockLocalStorageWorker.deletedFileName).to(equal("Lifts/turtle_lift/123456789.json"))
                    }
                }
                
                context("When the given lift does not belong to a workout") {
                    beforeEach {
                        lift = Lift(withName: "turtle lift")
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
