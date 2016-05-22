import Foundation

class LiftSet {
        private(set) var dataTemplate: LiftDataTemplate!
        var data: [String : AnyObject]!

        var lift: Lift?

        init(withDataTemplate dataTemplate: LiftDataTemplate, data: [String : AnyObject]) {
                self.dataTemplate = dataTemplate
                self.data = data
        }
}
