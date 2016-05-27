import Foundation
import Swinject

enum JSONSchemaType {
    case Double
    case Int
}

class LiftSetJSONValidator {
    init() { }
    
    func validateJSON(jsonData: [String : AnyObject], forDataTemplate dataTemplate: LiftDataTemplate)
        -> Bool {
            switch dataTemplate {
            case .WeightReps:
                return doesJSON(jsonData, satisfySchema: ["weight" : .Double, "reps" : .Int])
            case .HeightReps:
                return doesJSON(jsonData, satisfySchema: ["height" : .Double, "reps" : .Int])
            case .TimeInSeconds:
                return doesJSON(jsonData, satisfySchema: ["time(sec)" : .Double])
            case .WeightTimeInSeconds:
                return doesJSON(jsonData, satisfySchema: ["weight" : .Double, "time(sec)" : .Double])
            }
    }
    
    private func doesJSON(json: [String : AnyObject], satisfySchema schema: [String : JSONSchemaType]) -> Bool {
        for key in schema.keys {
            let value = json[key]
            if value == nil {
                return false
            }
            
            if let schemaType = schema[key] {
                switch schemaType {
                case .Double:
                    let castedValue = value as? Double
                    if castedValue == nil {
                        return false
                    }
                case .Int:
                    let castedValue = value as? Int
                    if castedValue == nil {
                        return false
                    }
                }
            }
        }
        
        return true
    }
}

extension LiftSetJSONValidator: Injectable {
    static func registerForInjection(container: Container) {
        container.register(LiftSetJSONValidator.self) { _ in
            return LiftSetJSONValidator()
        }
    }
}
