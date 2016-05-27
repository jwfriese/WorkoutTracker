import Foundation
import Swinject

class LiftSetDeserializer {
    private(set) var liftSetJSONValidator: LiftSetJSONValidator!
    
    func deserialize(liftSetDictionary: [String : AnyObject], usingDataTemplate dataTemplate: LiftDataTemplate) -> LiftSet? {
        if self.liftSetJSONValidator.validateJSON(liftSetDictionary, forDataTemplate: dataTemplate) {
            return LiftSet(withDataTemplate: dataTemplate, data: liftSetDictionary)
        }
        
        return nil
    }
}

extension LiftSetDeserializer: Injectable {
    static func registerForInjection(container: Container) {
        container.register(LiftSetDeserializer.self) { resolver in
            let instance = LiftSetDeserializer()
            
            instance.liftSetJSONValidator = resolver.resolve(LiftSetJSONValidator.self)
            
            return instance
        }
    }
}
