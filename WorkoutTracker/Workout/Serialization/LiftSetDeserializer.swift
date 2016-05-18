import Foundation

public class LiftSetDeserializer {
        public private(set) var liftSetJSONValidator: LiftSetJSONValidator!

        public init(withLiftSetJSONValidator liftSetJSONValidator: LiftSetJSONValidator?) {
                self.liftSetJSONValidator = liftSetJSONValidator
        }

        public func deserialize(liftSetDictionary: [String : AnyObject], usingDataTemplate dataTemplate: LiftDataTemplate) -> LiftSet? {
                if self.liftSetJSONValidator.validateJSON(liftSetDictionary, forDataTemplate: dataTemplate) {
                        return LiftSet(withDataTemplate: dataTemplate, data: liftSetDictionary)
                }

                return nil
        }
}
