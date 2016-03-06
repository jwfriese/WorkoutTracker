import Foundation

public class LiftDeserializer {
    public private(set) var liftSetDeserializer: LiftSetDeserializer?
    
    public init(withLiftSetDeserializer liftSetDeserializer: LiftSetDeserializer?) {
        self.liftSetDeserializer = liftSetDeserializer
    }
    
    public func deserialize(liftDictionary: [String : AnyObject]) -> Lift {
        let name = liftDictionary["name"] as! String
        
        let lift = Lift(withName: name)
        
        let setsArray = liftDictionary["sets"] as! Array<[String : AnyObject]>
        for set in setsArray {
            lift.addSet((liftSetDeserializer?.deserialize(set))!)
        }
        
        return lift
    }
}
