import Foundation

public class LiftSet {
    public var targetWeight: Double?
    public var performedWeight: Double
    public var targetReps: Int?
    public var performedReps: Int
    
    public var lift: Lift?
    
    public init(withTargetWeight targetWeight: Double?, performedWeight: Double,
        targetReps: Int?, performedReps: Int) {
            self.targetWeight = targetWeight
            self.performedWeight = performedWeight
            self.targetReps = targetReps
            self.performedReps = performedReps
    }
}
