import Quick
import Nimble
import WorkoutTracker

class WorkoutDeleteAgentSpec: QuickSpec {
    override func spec() {
        
        class MockLocalStorageWorker: LocalStorageWorker {
            var deletedFileName: String?
            
            override private func deleteFile(fileName: String!) throws {
                deletedFileName = fileName
            }
        }
        
        describe("WorkoutDeleteAgent") {
            var subject: WorkoutDeleteAgent!
            var mockLocalStorageWorker: MockLocalStorageWorker!
            
            beforeEach {
                mockLocalStorageWorker = MockLocalStorageWorker()
                subject = WorkoutDeleteAgent(withLocalStorageWorker: mockLocalStorageWorker)
            }
            
            describe("Its initializer") {
                it("sets the local storage worker") {
                    expect(subject.localStorageWorker).to(beIdenticalTo(mockLocalStorageWorker))
                }
            }
            
            describe("Deleting a workout") {
                var workout: Workout!
                
                beforeEach {
                    workout = Workout(withName: "turtle workout", timestamp: 2000)
                    subject.delete(workout)
                }
                
                it("deletes the file associated with the given workout from disk") {
                    expect(mockLocalStorageWorker.deletedFileName).to(equal("Workouts/2000_turtleworkout.json"))
                }
            }
        }
    }
}
