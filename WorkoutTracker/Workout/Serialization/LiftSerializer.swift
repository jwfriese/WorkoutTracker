import Foundation

public class LiftSerializer {
        public init() { }

        public func serialize(lift: Lift) -> [String : AnyObject] {
                var result = [String : AnyObject]()
                result["name"] = lift.name
                result["dataTemplate"] = lift.dataTemplate.rawValue
                var liftSetData = Array<[String :    AnyObject]>()
                for set in lift.sets {
                        liftSetData.append(set.data)
                }

                result["sets"] = liftSetData

                if let workoutIdentifier = lift.workout?.timestamp {
                        result["workout"] = workoutIdentifier
                }

                return result
        }
}
