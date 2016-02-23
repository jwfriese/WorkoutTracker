import Foundation
import Swinject

public class WorkoutStoryboardMetadata: SwinjectStoryboardMetadata {
    public var name: String {
        get {
            return "Workout"
        }
    }
    
    public var container: Container {
        get {
            let container = Container()
            
            container.register(Timestamper.self) { _ in
                return Timestamper()
            }
            container.register(WorkoutListViewModel.self) { resolver in
                return WorkoutListViewModel(withTimestamper: resolver.resolve(Timestamper.self)!)
            }
            container.registerForStoryboard(WorkoutListViewController.self) { resolver, instance in
                instance.viewModel = resolver.resolve(WorkoutListViewModel.self)
            }
            
            return container
        }
    }
}
