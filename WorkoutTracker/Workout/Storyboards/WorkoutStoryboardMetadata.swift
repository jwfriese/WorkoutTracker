import Foundation
import Swinject

public class WorkoutStoryboardMetadata: SwinjectStoryboardMetadata {
    public static var name: String {
        get {
            return "Workout"
        }
    }
    
    public static var container: Container {
        get {
            let container = Container()
            
            container.register(LocalStorageWorker.self) { resolver in
                return LocalStorageWorker()
            }
            
            container.register(WorkoutSerializer.self) { resolver in
                let liftSerializer = resolver.resolve(LiftSerializer.self)
                return WorkoutSerializer(withLiftSerializer: liftSerializer!)
            }
            
            container.register(LiftSerializer.self) { resolver in
                let liftSetSerializer = resolver.resolve(LiftSetSerializer.self)
                
                return LiftSerializer(withLiftSetSerializer: liftSetSerializer!)
            }
            
            container.register(LiftSetSerializer.self) { resolver in
                return LiftSetSerializer()
            }
            
            container.register(WorkoutSaveAgent.self) { resolver in
                let workoutSerializer = resolver.resolve(WorkoutSerializer.self)
                let localStorageWorker = resolver.resolve(LocalStorageWorker.self)
                
                return WorkoutSaveAgent(withWorkoutSerializer: workoutSerializer!,
                    localStorageWorker: localStorageWorker!)
            }
            
            container.registerForStoryboard(WorkoutViewController.self) { resolver, instance in
                instance.workoutSaveAgent = resolver.resolve(WorkoutSaveAgent.self)
            }
            
            container.registerForStoryboard(LiftViewController.self) { resolver, instance in
               instance.workoutSaveAgent = resolver.resolve(WorkoutSaveAgent.self)
            }
            
            return container
        }
    }
}
