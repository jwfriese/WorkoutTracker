import Foundation
import Swinject

public class WorkoutListStoryboardMetadata: SwinjectStoryboardMetadata {
    public static var name: String {
        get {
            return "WorkoutList"
        }
    }
    
    public static var container: Container {
        get {
            let container = Container()
            
            container.register(Timestamper.self) { _ in
                return Timestamper()
            }
            
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
            
            container.register(WorkoutDeserializer.self) { resolver in
                let liftDeserializer = resolver.resolve(LiftDeserializer.self)
                
                return WorkoutDeserializer(withLiftDeserializer: liftDeserializer)
            }
            
            container.register(LiftDeserializer.self) { resolver in
                let liftSetDeserializer = resolver.resolve(LiftSetDeserializer.self)
                
                return LiftDeserializer(withLiftSetDeserializer: liftSetDeserializer)
            }
            
            container.register(LiftSetDeserializer.self) { resolver in
                return LiftSetDeserializer()
            }
            
            container.register(WorkoutLoadAgent.self) { resolver in
                let workoutDeserializer = resolver.resolve(WorkoutDeserializer.self)
                let localStorageWorker = resolver.resolve(LocalStorageWorker.self)
                
                return WorkoutLoadAgent(withWorkoutDeserializer: workoutDeserializer!,
                    localStorageWorker: localStorageWorker!)
            }
    
            container.registerForStoryboard(WorkoutListViewController.self) { resolver, instance in
                instance.timestamper = resolver.resolve(Timestamper.self)
                instance.workoutSaveAgent = resolver.resolve(WorkoutSaveAgent.self)
                instance.workoutLoadAgent = resolver.resolve(WorkoutLoadAgent.self)
            }
            
            return container
        }
    }
}
