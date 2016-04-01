import Quick
import Nimble
import WorkoutTracker

class LiftCreatorSpec: QuickSpec {
    override func spec() {
        class MockLiftHistoryIndexLoader: LiftHistoryIndexLoader {
            var index: [String : [UInt]] = ["turtle lift" : [1000, 2000, 10000]]
            
            init() {
                super.init(withLocalStorageWorker: nil)
            }
            
            override private func load() -> [String : [UInt]] {
                return index
            }
        }
        
        class MockWorkoutLoadAgent: WorkoutLoadAgent {
            var workout: Workout?
            var rabbitLift = Lift(withName: "rabbit lift")
            var turtleLift = Lift(withName: "turtle lift")
            var mongooseLift = Lift(withName: "mongoose lift")
            
            init() {
                super.init(withWorkoutDeserializer: nil, localStorageWorker: nil)
                
                workout = Workout(withName: "turtle workout", timestamp: 10000)
                workout!.addLift(rabbitLift)
                workout!.addLift(turtleLift)
                workout!.addLift(mongooseLift)
            }
            
            override private func loadWorkout(withIdentifier workoutIdentifier: UInt) -> Workout? {
                if workoutIdentifier == 10000 {
                    return workout
                }
                
                return nil
            }
        }
        
        describe("LiftCreator") {
            var subject: LiftCreator!
            var mockLiftHistoryIndexLoader: MockLiftHistoryIndexLoader!
            var mockWorkoutLoadAgent: MockWorkoutLoadAgent!
            
            beforeEach {
                mockLiftHistoryIndexLoader = MockLiftHistoryIndexLoader()
                mockWorkoutLoadAgent = MockWorkoutLoadAgent()
                
                subject = LiftCreator(withLiftHistoryIndexLoader: mockLiftHistoryIndexLoader,
                    workoutLoadAgent: mockWorkoutLoadAgent)
            }
            
            describe("Its initializer") {
                it("sets its LiftHistoryIndexLoader") {
                    expect(subject.liftHistoryIndexLoader).to(beIdenticalTo(mockLiftHistoryIndexLoader))
                }
                
                it("sets its WorkoutLoadAgent") {
                    expect(subject.workoutLoadAgent).to(beIdenticalTo(mockWorkoutLoadAgent))
                }
            }
            
            describe("Creating a lift") {
                var lift: Lift?
                
                beforeEach {
                    lift = subject.createWithName("turtle lift")
                }
                
                it("produces a lift with the given name") {
                    expect(lift!.name).to(equal("turtle lift"))
                }
                
                it("sets the lift's previous lift on it") {
                    expect(lift?.previousInstance).to(beIdenticalTo(mockWorkoutLoadAgent.turtleLift))
                }
            }
        }
    }
}
