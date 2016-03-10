import Foundation

public class LiftSet {
    public var weight: Double
    public var reps: Int
    
    public var lift: Lift?
    
    public init(withWeight weight: Double, reps: Int) {
        self.weight = weight
        self.reps = reps
    }
}
