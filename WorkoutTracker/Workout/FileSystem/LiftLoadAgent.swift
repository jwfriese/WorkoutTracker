import Foundation
import Swinject

class LiftLoadAgent {
    private(set) var liftSetDeserializer: LiftSetDeserializer!
    private(set) var localStorageWorker: LocalStorageWorker!
    private(set) var liftHistoryIndexLoader: LiftHistoryIndexLoader!
    
    func loadLift(withName name: String, fromWorkoutWithIdentifier workoutIdentifier: UInt,
                           shouldLoadPreviousLift: Bool) -> Lift? {
        let liftNameSnakeCase = name.stringByReplacingOccurrencesOfString(" ", withString: "_")
        let liftFileName = "Lifts/\(liftNameSnakeCase)/\(String(workoutIdentifier)).json"
        let liftDictionary = localStorageWorker.readJSONDictionaryFromFile(liftFileName)
        
        if let name = liftDictionary?["name"] as? String {
            if let dataTemplateRaw = liftDictionary?["dataTemplate"] as? String {
                if let dataTemplate = LiftDataTemplate(rawValue: dataTemplateRaw) {
                    let lift = Lift(withName: name, dataTemplate: dataTemplate)
                    
                    let setsArray = liftDictionary!["sets"] as! Array<[String : AnyObject]>
                    
                    for set in setsArray {
                        if let deserializedSet = liftSetDeserializer.deserialize(set, usingDataTemplate: dataTemplate) {
                            lift.addSet(deserializedSet)
                        }
                    }
                    
                    if shouldLoadPreviousLift {
                        let liftHistory = liftHistoryIndexLoader.load()
                        if let lifts = liftHistory[name] {
                            if lifts.count > 0 {
                                if let previousLiftWorkoutIdentifier = lifts.lastSatisfyingPredicate({ workout in workout < workoutIdentifier }) {
                                    lift.previousInstance = loadLift(withName: name,
                                                                     fromWorkoutWithIdentifier: previousLiftWorkoutIdentifier,
                                                                     shouldLoadPreviousLift: false)
                                }
                            }
                        }
                    }
                    
                    return lift
                }
            }
        }
        
        return nil
    }
    
    func loadLatestLiftWithName(name: String) -> Lift? {
        let liftHistoryIndex = liftHistoryIndexLoader.load()
        if let latestWorkoutIdentifier = liftHistoryIndex[name]?.last {
            return loadLift(withName: name, fromWorkoutWithIdentifier: latestWorkoutIdentifier,
                            shouldLoadPreviousLift: true)
        }
        
        return nil
    }
}

extension LiftLoadAgent: Injectable {
    static func registerForInjection(container: Container) {
        container.register(LiftLoadAgent.self) { resolver in
            let instance = LiftLoadAgent()
            
            instance.liftSetDeserializer = resolver.resolve(LiftSetDeserializer.self)
            instance.liftHistoryIndexLoader = resolver.resolve(LiftHistoryIndexLoader.self)
            instance.localStorageWorker = resolver.resolve(LocalStorageWorker.self)
            
            return instance
        }
    }
}
