import Quick
import Nimble
@testable import WorkoutTracker

class LiftHistoryIndexLoaderSpec: QuickSpec {
    override func spec() {
        class MockLocalStorageWorker: LocalStorageWorker {
            var index: [String : [UInt]] = ["turtle example" : [10,8,6]]
            
            override func readJSONDictionaryFromFile(fileName: String!) -> Dictionary<String, AnyObject>? {
                if fileName == "Indices/LiftHistory.json" {
                    return index
                }
                
                return nil
            }
        }
        
        describe("LiftHistoryIndexLoader") {
            var subject: LiftHistoryIndexLoader!
            var mockLocalStorageWorker: MockLocalStorageWorker!
            
            beforeEach {
                mockLocalStorageWorker = MockLocalStorageWorker()
                subject = LiftHistoryIndexLoader(withLocalStorageWorker: mockLocalStorageWorker)
            }
            
            describe("Its initializer") {
                it("sets the LocalStorageWorker") {
                    expect(subject.localStorageWorker).to(beIdenticalTo(mockLocalStorageWorker))
                }
            }
            
            describe("Loading the lift history index") {
                var index: [String : [UInt]]?
                
                beforeEach {
                    index = subject.load()
                }
                
                it("loads the lift history index from disk") {
                    expect(index?["turtle example"]).to(equal([10,8,6]))
                }
            }
        }
    }
}
