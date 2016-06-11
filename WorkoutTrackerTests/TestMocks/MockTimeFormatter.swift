import Foundation
@testable import WorkoutTracker

class MockTimeFormatter: TimeFormatter {
    private var mockSqlTimestamptzStringFromIntegerTimestamp = [UInt : String]()
    
    func setSqlTimestamptzStringFromIntegerTimestamp(value: String, forInput input: UInt) {
        mockSqlTimestamptzStringFromIntegerTimestamp[input] = value
    }
    
    override func sqlTimestamptzStringFromIntegerTimestamp(timestamp: UInt) -> String {
        if let value = mockSqlTimestamptzStringFromIntegerTimestamp[timestamp] {
            return value
        }
        
        return ""
    }
    
    private var mockIntegerTimestampFromSqlTimestamptzString = [String : UInt]()
    
    func setIntegerTimestampFromSqlTimestamptzString(value: UInt, forInput input: String) {
        mockIntegerTimestampFromSqlTimestamptzString[input] = value
    }
    
    override func integerTimestampFromSqlTimestamptzString(sqlTimestamp: String) -> UInt {
        if let value = mockIntegerTimestampFromSqlTimestamptzString[sqlTimestamp] {
            return value
        }
        
        return 0
    }
}
