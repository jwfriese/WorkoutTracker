import Foundation
import Swinject

public class SerializationContainerModule {
    public static func setUpContainer(container: Container) {
        container.register(LiftSetSerializer.self) { resolver in
            return LiftSetSerializer()
        }
        
        container.register(LiftSerializer.self) { resolver in
            return LiftSerializer(withLiftSetSerializer: resolver.resolve(LiftSetSerializer.self)!)
        }
        
        container.register(WorkoutSerializer.self) { resolver in
            return WorkoutSerializer(withLiftSerializer: resolver.resolve(LiftSerializer.self)!)
        }
    }
}
