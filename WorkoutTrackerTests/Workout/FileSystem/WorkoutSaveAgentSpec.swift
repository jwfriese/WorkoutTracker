import Quick
import Nimble
import WorkoutTracker

class WorkoutSaveAgentSpec: QuickSpec {
    override func spec() {
        
        class MockWorkoutSerializer: WorkoutSerializer {
            var serializedWorkout: [String : AnyObject] = ["key" : "value"]
            
            init() {
                super.init(withLiftSerializer: LiftSerializer(withLiftSetSerializer: LiftSetSerializer()))
            }
            
            override func serialize(workout: Workout) -> [String : AnyObject] {
                return serializedWorkout
            }
        }
        
        class MockLocalStorageWorker: LocalStorageWorker {
            var savedDictionary: [String : AnyObject]?
            
            override private func writeJSONDictionary(dictionary: Dictionary<String, AnyObject>, toFileWithName name: String!,
                createSubdirectories: Bool) {
                savedDictionary = dictionary
            }
        }
        
        describe("WorkoutSaveAgent") {
            var subject: WorkoutSaveAgent!
            var mockWorkoutSerializer: MockWorkoutSerializer!
            var mockLocalStorageWorker: MockLocalStorageWorker!
            
            beforeEach {
                mockWorkoutSerializer = MockWorkoutSerializer()
                mockLocalStorageWorker = MockLocalStorageWorker()
                
                subject = WorkoutSaveAgent(withWorkoutSerializer: mockWorkoutSerializer,
                    localStorageWorker: mockLocalStorageWorker)
            }
            
            describe("Its initializer") {
                it("sets a workout serializer") {
                    expect(subject.workoutSerializer).toNot(beNil())
                }
                
                it("sets a local storage worker") {
                    expect(subject.localStorageWorker).toNot(beNil())
                }
            }
            
            describe("Saving a workout") {
                var workout: Workout!
                var savedFileName: String?
                
                beforeEach {
                    workout = Workout(withName: "turtle workout", timestamp: 1000)
                    
                    savedFileName = subject.save(workout)
                }
                
                it("serializes the workout and uses the local storage worker to save the data to disk") {
                    if let savedDictionary = mockLocalStorageWorker.savedDictionary {
                        expect(unsafeAddressOf(savedDictionary)).to(equal(unsafeAddressOf(mockWorkoutSerializer.serializedWorkout)))
                        expect(savedFileName).to(equal("Workouts/1000_turtleworkout.json"))
                    } else {
                        fail("Failed to save the workout to disk")
                    }
                }
            }
        }
    }
}
