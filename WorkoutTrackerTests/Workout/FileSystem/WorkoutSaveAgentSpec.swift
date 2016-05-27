import Quick
import Nimble
import Swinject
@testable import WorkoutTracker

class WorkoutSaveAgentSpec: QuickSpec {
    override func spec() {
        
        class MockWorkoutSerializer: WorkoutSerializer {
            var serializedWorkout: [String : AnyObject] = ["key" : "value"]
            
            override func serialize(workout: Workout) -> [String : AnyObject] {
                return serializedWorkout
            }
        }
        
        class MockLiftSaveAgent: LiftSaveAgent {
            var savedLifts: [Lift] = []
            
            override func save(lift: Lift) {
                savedLifts.append(lift)
            }
        }
        
        class MockLocalStorageWorker: LocalStorageWorker {
            var savedDictionary: [String : AnyObject]?
            
            override private func writeJSONDictionary(dictionary: Dictionary<String, AnyObject>, toFileWithName name: String!, createSubdirectories: Bool) {
                savedDictionary = dictionary
            }
        }
        
        describe("WorkoutSaveAgent") {
            var subject: WorkoutSaveAgent!
            var container: Container!
            var mockWorkoutSerializer: MockWorkoutSerializer!
            var mockLiftSaveAgent: MockLiftSaveAgent!
            var mockLocalStorageWorker: MockLocalStorageWorker!
            
            beforeEach {
                container = Container()
                
                mockWorkoutSerializer = MockWorkoutSerializer()
                container.register(WorkoutSerializer.self) { _ in
                    return mockWorkoutSerializer
                }
                
                mockLiftSaveAgent = MockLiftSaveAgent()
                container.register(LiftSaveAgent.self) { _ in
                    return mockLiftSaveAgent
                }
                
                mockLocalStorageWorker = MockLocalStorageWorker()
                container.register(LocalStorageWorker.self) { _ in
                    return mockLocalStorageWorker
                }
                
                WorkoutSaveAgent.registerForInjection(container)
                subject = container.resolve(WorkoutSaveAgent.self)
            }
            
            describe("Its injection") {
                it("sets its workout serializer") {
                    expect(subject.workoutSerializer).to(beIdenticalTo(mockWorkoutSerializer))
                }
                
                it("sets its lift save agent") {
                    expect(subject.liftSaveAgent).to(beIdenticalTo(mockLiftSaveAgent))
                }
                
                it("sets its local storage worker") {
                    expect(subject.localStorageWorker).to(beIdenticalTo(mockLocalStorageWorker))
                }
            }
            
            describe("Saving a workout") {
                var workout: Workout!
                var liftOne: Lift!
                var liftTwo: Lift!
                var savedFileName: String?
                
                beforeEach {
                    liftOne = Lift(withName: "turtle lift", dataTemplate: .WeightReps)
                    liftTwo = Lift(withName: "turtle press", dataTemplate: .WeightReps)
                    
                    workout = Workout(withName: "turtle workout", timestamp: 1000)
                    workout.addLift(liftOne)
                    workout.addLift(liftTwo)
                    
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
                
                it("passes each of its lifts to the lift save agent") {
                    expect(mockLiftSaveAgent.savedLifts).to(contain(liftOne))
                    expect(mockLiftSaveAgent.savedLifts).to(contain(liftTwo))
                }
            }
        }
    }
}
