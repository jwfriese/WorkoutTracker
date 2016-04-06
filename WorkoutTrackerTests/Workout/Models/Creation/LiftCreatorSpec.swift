import Quick
import Nimble
import WorkoutTracker

class LiftCreatorSpec: QuickSpec {
    override func spec() {
        
        class MockLiftLoadAgent: LiftLoadAgent {
            var loadedLift: Lift?
            
            init() {
                super.init(withLiftSetDeserializer: nil, localStorageWorker: nil, liftHistoryIndexLoader: nil)
            }
            
            override private func loadLatestLiftWithName(name: String) -> Lift? {
                loadedLift = Lift(withName: name)
                return loadedLift
            }
        }
        
        describe("LiftCreator") {
            var subject: LiftCreator!
            var mockLiftLoadAgent: MockLiftLoadAgent!
            
            beforeEach {
                mockLiftLoadAgent = MockLiftLoadAgent()
                
                subject = LiftCreator(liftLoadAgent: mockLiftLoadAgent)
            }
            
            describe("Its initializer") {                
                it("sets its LiftLoadAgent") {
                    expect(subject.liftLoadAgent).to(beIdenticalTo(mockLiftLoadAgent))
                }
            }
            
            describe("Creating a lift") {
                var lift: Lift?
                
                beforeEach {
                    lift = subject.createWithName("turtle lift")
                }
                
                it("produces a lift with the given name") {
                    expect(lift?.name).to(equal("turtle lift"))
                }
                
                it("tries to load the latest lift with the given name as the previous instance") {
                    expect(lift?.previousInstance).to(beIdenticalTo(mockLiftLoadAgent.loadedLift))
                }
            }
        }
    }
}
