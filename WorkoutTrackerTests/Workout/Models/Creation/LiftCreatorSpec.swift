import Quick
import Nimble
import Swinject
@testable import WorkoutTracker

class LiftCreatorSpec: QuickSpec {
    override func spec() {
        
        class MockLiftLoadAgent: LiftLoadAgent {
            var loadedLift: Lift?
            
            override private func loadLatestLiftWithName(name: String) -> Lift? {
                loadedLift = Lift(withName: name, dataTemplate: .WeightReps)
                return loadedLift
            }
        }
        
        describe("LiftCreator") {
            var subject: LiftCreator!
            var container: Container!
            var mockLiftLoadAgent: MockLiftLoadAgent!
            
            beforeEach {
                container = Container()
                
                mockLiftLoadAgent = MockLiftLoadAgent()
                container.register(LiftLoadAgent.self) { _ in return mockLiftLoadAgent }
                
                LiftCreator.registerForInjection(container)
                
                subject = container.resolve(LiftCreator.self)
            }
            
            describe("Its injection") {
                it("sets its LiftLoadAgent") {
                    expect(subject.liftLoadAgent).to(beIdenticalTo(mockLiftLoadAgent))
                }
            }
            
            describe("Creating a lift") {
                var lift: Lift?
                
                beforeEach {
                    lift = subject.createWithName("turtle lift", dataTemplate: .TimeInSeconds)
                }
                
                it("produces a lift with the given name and data template") {
                    expect(lift?.name).to(equal("turtle lift"))
                    expect(lift?.dataTemplate).to(equal(LiftDataTemplate.TimeInSeconds))
                }
                
                it("tries to load the latest lift with the given name as the previous instance") {
                    expect(lift?.previousInstance).to(beIdenticalTo(mockLiftLoadAgent.loadedLift))
                }
            }
        }
    }
}
