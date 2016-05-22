import Foundation

class LiftSetDeserializer {
        private(set) var liftSetJSONValidator: LiftSetJSONValidator!

        init(withLiftSetJSONValidator liftSetJSONValidator: LiftSetJSONValidator?) {
                self.liftSetJSONValidator = liftSetJSONValidator
        }

        func deserialize(liftSetDictionary: [String : AnyObject], usingDataTemplate dataTemplate: LiftDataTemplate) -> LiftSet? {
                if self.liftSetJSONValidator.validateJSON(liftSetDictionary, forDataTemplate: dataTemplate) {
                        return LiftSet(withDataTemplate: dataTemplate, data: liftSetDictionary)
                }

                return nil
        }
}
