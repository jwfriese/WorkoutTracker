import Foundation

class Lift {
        var name: String!
        var dataTemplate: LiftDataTemplate!
        private(set) var sets: [LiftSet] = []

        var workout: Workout?
        var previousInstance: Lift?

        init(withName name: String, dataTemplate: LiftDataTemplate) {
                self.name = name
                self.dataTemplate = dataTemplate
        }

        func addSet(set: LiftSet) {
                sets.append(set)
                set.lift = self
        }

        func isSame(otherLift: Lift) -> Bool {
                return self.name == otherLift.name && self.dataTemplate == otherLift.dataTemplate
        }
}
