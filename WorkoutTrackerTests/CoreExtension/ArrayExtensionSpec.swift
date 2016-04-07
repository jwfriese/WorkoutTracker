import Quick
import Nimble

class ArrayExtensionSpec: QuickSpec {
    override func spec() {
        describe("Finding the last value in an array satisfying a predicate") {
            let array:[UInt] = [1, 2, 3, 4, 5, 6, 7, 8]
            var result: UInt?
            
            context("When no values satisfying the predicate can be found") {
                beforeEach {
                    result = array.lastSatisfyingPredicate { value in
                        return value < 1
                    }
                }
                
                it("returns nil") {
                    expect(result).to(beNil())
                }
            }
            
            context("When at least one value satisfying the predicate can be found") {
                beforeEach {
                    result = array.lastSatisfyingPredicate { value in
                        return value < 7
                    }
                }
                
                it("returns the last value in the array that satisfies the predicate") {
                    expect(result).to(equal(6))
                }
            }
        }
    }
}
