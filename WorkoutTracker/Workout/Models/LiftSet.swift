import Foundation

public class LiftSet {
        public private(set) var dataTemplate: LiftDataTemplate!
        public var data: [String : AnyObject]!

        public var lift: Lift?

        public init(withDataTemplate dataTemplate: LiftDataTemplate, data: [String : AnyObject]) {
                self.dataTemplate = dataTemplate
                self.data = data
        }
}
