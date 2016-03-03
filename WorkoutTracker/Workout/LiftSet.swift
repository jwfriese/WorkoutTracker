import Foundation

public class LiftSet {
    public private(set) var weight: Double
    public private(set) var reps: Int
    
    public init(withWeight weight: Double, reps: Int) {
        self.weight = weight
        self.reps = reps
    }
}
