import Quick
import Nimble
import Swinject
@testable import WorkoutTracker

class TimeFormatterSpec: QuickSpec {
    override func spec() {
        describe("TimeFormatter -") {
            var subject: TimeFormatter!
            
            beforeEach {
                let container = Container()
                
                TimeFormatter.registerForInjection(container)
                subject = container.resolve(TimeFormatter.self)
            }
            
            describe("Converting an integer timestamp into an SQL timestamptz string") {
                var stringifiedTimestamp: String?
                
                context("When starting with a timestamp in DST") {
                    // March 16, 2016 5:46:51 AM DST
                    let timestamp: UInt = 1458132411
                    
                    beforeEach {
                        stringifiedTimestamp = subject.sqlTimestamptzStringFromIntegerTimestamp(timestamp)
                    }
                    
                    it("creates a string in the proper format") {
                        expect(stringifiedTimestamp).to(equal("2016-03-16 05:46:51-0700"))
                    }
                }
                
                context("When starting with a timestamp not in DST") {
                    // March 07, 2016 06:26:34 AM
                    let timestamp: UInt = 1457360794
                    
                    beforeEach {
                        stringifiedTimestamp = subject.sqlTimestamptzStringFromIntegerTimestamp(timestamp)
                    }
                    
                    it("creates a string in the proper format") {
                        expect(stringifiedTimestamp).to(equal("2016-03-07 06:26:34-0800"))
                    }
                }
            }
            
            describe("Converting an SQL timestamptz string into an integer timestamp") {
                var timestamp: UInt?
                
                beforeEach {
                    timestamp = subject.integerTimestampFromSqlTimestamptzString("2016-03-07 06:26:34-0800")
                }
                
                it("converts to the correct integer") {
                    expect(timestamp).to(equal(1457360794))
                }
            }
        }
    }
}
