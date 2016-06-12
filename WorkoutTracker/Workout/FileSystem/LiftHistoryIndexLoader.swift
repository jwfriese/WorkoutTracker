import Foundation
import Swinject

class LiftHistoryIndexLoader {
    var localStorageWorker: LocalStorageWorker!
    
    func load() -> [String: [UInt]]? {
        var index: [String : [UInt]]? = nil
        do {
            index = try localStorageWorker.readJSONDictionaryFromFile("Indices/LiftHistory.json") as? [String : [UInt]]
        } catch {
            print("*** Failed to read from Indices/LiftHistory.json ***")
            index = nil
        }
        
        return index
    }
}

extension LiftHistoryIndexLoader: Injectable {
    static func registerForInjection(container: Container) {
        container.register(LiftHistoryIndexLoader.self) { resolver in
            let instance = LiftHistoryIndexLoader()
            
            instance.localStorageWorker = resolver.resolve(LocalStorageWorker.self)
            
            return instance
        }
    }
}
