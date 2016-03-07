import Quick
import Nimble
import WorkoutTracker

class WorkoutLoadAgentSpec: QuickSpec {
    override func spec() {
        
        class MockLocalStorageWorker: LocalStorageWorker {
            var fileRead: String?
            
            override func allFilesWithExtension(ext: String!, recursive: Bool,
                startingDirectory: String) -> [String] {
                
                    var workoutFiles = [String]()
                    if startingDirectory == "Workouts" {
                        workoutFiles = ["turtle one", "turtle two", "turtle three"]
                    }
                    
                    return workoutFiles
            }
            
            override func readJSONDictionaryFromFile(fileName: String!) -> Dictionary<String, AnyObject>? {
                fileRead = fileName
                return ["name" : fileName]
            }
        }
        
        class MockWorkoutDeserializer: WorkoutDeserializer {
            var deserializedWorkout: Workout?
            
            init() {
                super.init(withLiftDeserializer: nil)
            }
            
            override func deserialize(workoutDictionary: [String : AnyObject]) -> Workout {
                deserializedWorkout = Workout(withName: workoutDictionary["name"] as! String,
                    timestamp: 0)
                return deserializedWorkout!
            }
        }
        
        describe("WorkoutLoadAgent") {
            var subject: WorkoutLoadAgent!
            var mockWorkoutDeserializer: MockWorkoutDeserializer!
            var mockLocalStorageWorker: MockLocalStorageWorker!
            
            beforeEach {
                mockWorkoutDeserializer = MockWorkoutDeserializer()
                mockLocalStorageWorker = MockLocalStorageWorker()
                
                subject = WorkoutLoadAgent(withWorkoutDeserializer: mockWorkoutDeserializer,
                    localStorageWorker: mockLocalStorageWorker)
            }
            
            describe("Its initializer") {
                it("sets its workout deserializer") {
                    expect(subject.workoutDeserializer).to(beIdenticalTo(mockWorkoutDeserializer))
                }
                
                it("sets its local storage worker") {
                    expect(subject.localStorageWorker).to(beIdenticalTo(mockLocalStorageWorker))
                }
            }
            
            describe("Loading a single workout from disk") {
                var workout: Workout!
                
                beforeEach {
                    workout = subject.load("storedWorkout.json")
                }
                
                it("uses the local storage worker to load the data from disk and deserializes the workout") {
                    if mockLocalStorageWorker.fileRead == "storedWorkout.json" {
                        expect(mockWorkoutDeserializer.deserializedWorkout).to(beIdenticalTo(workout))
                    } else {
                        fail("Failed to load the workout from disk")
                    }
                }
            }
            
            describe("Loading all workouts from disk") {
                var workouts: [Workout]!
                
                beforeEach {
                    workouts = subject.loadAllWorkouts()
                }
                
                it("uses the local storage worker to load all workout data from disk and deserialzes them") {
                    expect(workouts.count).to(equal(3))
                    expect(workouts[0].name).to(equal("turtle one"))
                    expect(workouts[1].name).to(equal("turtle two"))
                    expect(workouts[2].name).to(equal("turtle three"))
                }
            }
        }
    }
}