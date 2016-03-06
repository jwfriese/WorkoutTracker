import Quick
import Nimble
import Swinject
import WorkoutTracker

class SerializationContainerModuleSpec: QuickSpec {
    override func spec() {
        describe("SerializationContainerModule") {
            var container: Container!
            
            beforeEach {
                container = Container()
            }
            
            describe("Setting up the given container") {
                beforeEach {
                    SerializationContainerModule.setUpContainer(container)
                }
                
                describe("A WorkoutSerializer in the container") {
                    var workoutSerializer: WorkoutSerializer?
                    
                    beforeEach {
                        workoutSerializer = container.resolve(WorkoutSerializer.self)
                    }
                    
                    it("is created") {
                        expect(workoutSerializer).toNot(beNil())
                    }
                    
                    it("has a LiftSerializer set on it") {
                        expect(workoutSerializer?.liftSerializer).toNot(beNil())
                    }
                    
                    describe("Its LiftSerializer") {
                        var liftSerializer: LiftSerializer?
                        
                        beforeEach {
                            liftSerializer = workoutSerializer?.liftSerializer
                        }
                        
                        it("has a LiftSetSerializer") {
                            expect(liftSerializer?.liftSetSerializer).toNot(beNil())
                        }
                    }
                }
            }
        }
    }
}
