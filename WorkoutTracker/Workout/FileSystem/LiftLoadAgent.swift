import Foundation

public class LiftLoadAgent {
    public private(set) var liftSetDeserializer: LiftSetDeserializer!
    public private(set) var localStorageWorker: LocalStorageWorker!
    
    public init(withLiftSetDeserializer liftSetDeserializer: LiftSetDeserializer?, localStorageWorker: LocalStorageWorker?) {
        self.liftSetDeserializer = liftSetDeserializer
        self.localStorageWorker = localStorageWorker
    }
    
    public func loadLift(withName name: String, fromWorkoutWithIdentifier workoutIdentifier: UInt) -> Lift? {
        return loadLift(withName: name, fromWorkoutWithIdentifier: workoutIdentifier, shouldLoadPreviousLift: true)
    }
    
    private func loadLift(withName name: String, fromWorkoutWithIdentifier workoutIdentifier: UInt,
                             shouldLoadPreviousLift: Bool) -> Lift? {
        let liftNameSnakeCase = name.stringByReplacingOccurrencesOfString(" ", withString: "_")
        let liftFileName = "Lifts/\(liftNameSnakeCase)/\(String(workoutIdentifier)).json"
        let liftDictionary = localStorageWorker.readJSONDictionaryFromFile(liftFileName)
        
        let name = liftDictionary!["name"] as! String
        
        let lift = Lift(withName: name)
        
        let setsArray = liftDictionary!["sets"] as! Array<[String : AnyObject]>
        for set in setsArray {
            lift.addSet((liftSetDeserializer.deserialize(set))!)
        }
        
        if shouldLoadPreviousLift {
            if let previousLiftInstanceWorkoutIdentifier = liftDictionary!["previousLiftWorkoutIdentifier"] as? UInt {
                lift.previousInstance = loadLift(withName: name, fromWorkoutWithIdentifier: previousLiftInstanceWorkoutIdentifier,
                                                 shouldLoadPreviousLift: false)
            }
        }
        
        return lift
    }
}
