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
            
            return container
        }
    }
}
