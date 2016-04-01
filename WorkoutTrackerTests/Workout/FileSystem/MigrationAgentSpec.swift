import Quick
import Nimble
import WorkoutTracker

class MigrationAgentSpec: QuickSpec {
    override func spec() {
        class MockLiftHistoryIndexBuilder: LiftHistoryIndexBuilder {
            var indexedWorkouts: [Workout]?
            var output: [String : [UInt]]?
            
            override func buildIndexFromWorkouts(workouts: [Workout]) -> [String : [UInt]] {
                indexedWorkouts = workouts
                output = [String : [UInt]]()
                output!["turtle"] = [1,2,3]
                return output!
            }
        }
        
        class MockWorkoutLoadAgent: WorkoutLoadAgent {
            var allWorkouts: [Workout]?
            
            init() {
                super.init(withWorkoutDeserializer: nil, localStorageWorker: nil)
            }
            
            override func loadAllWorkouts() -> [Workout] {
                if let workouts = allWorkouts {
                    return workouts
                }
                
                return []
            }
        }
        
        class MockLocalStorageWorker: LocalStorageWorker {
            var savedJSONDictionary: [String : AnyObject]?
            var savedFileName: String?
            
            override func writeJSONDictionary(dictionary: Dictionary<String, AnyObject>, toFileWithName name: String!, createSubdirectories: Bool) throws {
                
                savedJSONDictionary = dictionary
                savedFileName = name
            }
        }
        
        describe("MigrationAgent") {
            var subject: MigrationAgent!
            var mockLiftHistoryIndexBuilder: MockLiftHistoryIndexBuilder!
            var mockWorkoutLoadAgent: MockWorkoutLoadAgent!
            var mockLocalStorageWorker: MockLocalStorageWorker!
            
            beforeEach {
                mockLiftHistoryIndexBuilder = MockLiftHistoryIndexBuilder()
                mockWorkoutLoadAgent = MockWorkoutLoadAgent()
                mockLocalStorageWorker = MockLocalStorageWorker()
                
                subject = MigrationAgent(withLiftHistoryIndexBuilder: mockLiftHistoryIndexBuilder, workoutLoadAgent: mockWorkoutLoadAgent, localStorageWorker: mockLocalStorageWorker)
            }
            
            describe("Its initializer") {
                it("sets its lift history index builder") {
                    expect(subject.liftHistoryIndexBuilder).to(beIdenticalTo(mockLiftHistoryIndexBuilder))
                }
                
                it("sets its workout load agent") {
                    expect(subject.workoutLoadAgent).to(beIdenticalTo(mockWorkoutLoadAgent))
                }
                
                it("sets its local storage worker") {
                    expect(subject.localStorageWorker).to(beIdenticalTo(mockLocalStorageWorker))
                }
            }
            
            describe("Its migration work") {
                var didCallCompletionHandler: Bool = false
                var mockLoadedWorkouts: [Workout]!
                
                beforeEach {
                    mockLoadedWorkouts = [Workout(withName: "workout", timestamp: 1000)]
                    mockWorkoutLoadAgent.allWorkouts = mockLoadedWorkouts
                    subject.performMigrationWork() {
                        didCallCompletionHandler = true
                    }
                }
                
                it("builds a lift history index from loaded workouts") {
                    if let indexedWorkouts = mockLiftHistoryIndexBuilder.indexedWorkouts {
                        expect(indexedWorkouts.first?.name).to(equal("workout"))
                        expect(indexedWorkouts.first?.timestamp).to(equal(1000))
                    } else {
                        fail("Expected to create lift history index from loaded workouts")
                    }
                }
                
                it("saves the built lift history index") {
                    let savedJSONDictionaryArray = mockLocalStorageWorker.savedJSONDictionary!["turtle"] as! [UInt]
                    expect(savedJSONDictionaryArray).to(equal([1,2,3]))
                }
                
                it("chooses the correct file to save the index in") {
                    expect(mockLocalStorageWorker.savedFileName).to(equal("Indices/LiftHistory.json"))
                }
                
                it("calls the given completion handler") {
                    expect(didCallCompletionHandler).to(beTrue())
                }
            }
        }
    }
}
