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
    
            container.registerForStoryboard(WorkoutListViewController.self) { resolver, instance in
                instance.timestamper = resolver.resolve(Timestamper.self)
            }
            
            return container
        }
    }
}
