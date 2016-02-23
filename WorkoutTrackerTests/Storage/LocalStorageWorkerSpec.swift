import Quick
import Nimble
import WorkoutTracker

class LocalStorageWorkerSpec: QuickSpec {
    override func spec() {
        describe("LocalStorageWorker") {
            var subject: LocalStorageWorker!
            var documentsDirectoryPath: String!
            
            beforeEach {
                subject = LocalStorageWorker()
                documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
            }
            
            describe("Working with file system data") {
                describe("Reading and writing data") {
                    var testImage: UIImage?
                    
                    beforeEach {
                        testImage = UIImage(named:"testImage.jpg", inBundle: NSBundle(forClass: self.dynamicType), compatibleWithTraitCollection: nil)
                    }
                    
                    afterEach {
                        try! NSFileManager.defaultManager().removeItemAtPath(documentsDirectoryPath + "/integrationTest.jpg")
                    }
                    
                    it("should be able to save data and fetch that same data back") {
                        subject.writeData(UIImageJPEGRepresentation(testImage!, 1.0), toFileWithName: "integrationTest.jpg")
                        let fetchedData = subject.readDataFromFile("integrationTest.jpg")
                        expect(fetchedData).to(equal(UIImageJPEGRepresentation(testImage!, 1.0)))
                    }
                }
                
                describe("Fetching file names") {
                    beforeEach {
                        let dataStringOne = "dolphins"
                        let dataStringTwo = "kittens"
                        let dataStringThree = "turtles"
                        
                        subject.writeData(dataStringOne.dataUsingEncoding(NSUTF8StringEncoding), toFileWithName: "100.jpg")
                        subject.writeData(dataStringTwo.dataUsingEncoding(NSUTF8StringEncoding), toFileWithName:  "200.jpg")
                        subject.writeData(dataStringThree.dataUsingEncoding(NSUTF8StringEncoding), toFileWithName: "300.jpg")
                    }
                    
                    afterEach {
                        try! NSFileManager.defaultManager().removeItemAtPath(documentsDirectoryPath + "/100.jpg")
                        try! NSFileManager.defaultManager().removeItemAtPath(documentsDirectoryPath + "/200.jpg")
                        try! NSFileManager.defaultManager().removeItemAtPath(documentsDirectoryPath + "/300.jpg")
                    }
                    
                    it("should be able to save a group of files and fetch their names afterward") {
                        let fileNames = subject.allFilesWithExtension("jpg")
                        expect(fileNames.count).to(equal(3))
                        expect(fileNames).to(contain("100.jpg"))
                        expect(fileNames).to(contain("200.jpg"))
                        expect(fileNames).to(contain("300.jpg"))
                    }
                }
                
                describe("Deleting data") {
                    describe("Deleting individual files") {
                        var testData: NSData!
                        
                        beforeEach {
                            let dataString = "turtle power"
                            testData = dataString.dataUsingEncoding(NSUTF8StringEncoding)
                            subject.writeData(testData, toFileWithName: "testDeletion.jpg")
                        }
                        
                        it("should be able to delete a file in the system") {
                            expect(subject.readDataFromFile("testDeletion.jpg")).to(equal(testData))
                            
                            try! subject.deleteFile("testDeletion.jpg")
                            
                            expect(subject.readDataFromFile("testDeletion.jpg")).to(beNil())
                        }
                    }
                    
                    describe("Deleting all files of a type") {
                        var testDataOne: NSData!
                        var testDataTwo: NSData!
                        var testDataThree: NSData!
                        var testDataFour: NSData!
                        
                        beforeEach {
                            let dataStringOne = "turtle power"
                            testDataOne = dataStringOne.dataUsingEncoding(NSUTF8StringEncoding)
                            subject.writeData(testDataOne, toFileWithName: "testDeletionOne.jpg")
                            
                            let dataStringTwo = "turtle strength"
                            testDataTwo = dataStringTwo.dataUsingEncoding(NSUTF8StringEncoding)
                            subject.writeData(testDataTwo, toFileWithName: "testDeletionTwo.jpg")
                            
                            let dataStringThree = "turtle might"
                            testDataThree = dataStringThree.dataUsingEncoding(NSUTF8StringEncoding)
                            subject.writeData(testDataThree, toFileWithName: "testDeletionThree.jpg")
                            
                            let dataStringFour = "turtle might"
                            testDataFour = dataStringFour.dataUsingEncoding(NSUTF8StringEncoding)
                            subject.writeData(testDataFour, toFileWithName: "testDeletionFour.png")
                        }
                        
                        it("should be able to delete all files of a certain type from the system") {
                            expect(subject.readDataFromFile("testDeletionOne.jpg")).to(equal(testDataOne))
                            expect(subject.readDataFromFile("testDeletionTwo.jpg")).to(equal(testDataTwo))
                            expect(subject.readDataFromFile("testDeletionThree.jpg")).to(equal(testDataThree))
                            expect(subject.readDataFromFile("testDeletionFour.png")).to(equal(testDataFour))
                            
                            try! subject.deleteAllFilesWithExtension("jpg")
                            
                            expect(subject.readDataFromFile("testDeletionOne.jpg")).to(beNil())
                            expect(subject.readDataFromFile("testDeletionTwo.jpg")).to(beNil())
                            expect(subject.readDataFromFile("testDeletionThree.jpg")).to(beNil())
                            expect(subject.readDataFromFile("testDeletionFour.png")).to(equal(testDataFour))
                        }
                    }
                }
            }
            
            describe("#writeData(data:toFileWithName:)") {
                var image: UIImage?
                var imageData: NSData?
                
                beforeEach {
                    image = UIImage(named:"testImage.jpg", inBundle: NSBundle(forClass: self.dynamicType), compatibleWithTraitCollection: nil)
                    imageData = UIImageJPEGRepresentation(image!, 1.0)
                    subject.writeData(imageData, toFileWithName: "testImageFileName.jpg")
                }
                
                afterEach {
                    try! NSFileManager.defaultManager().removeItemAtPath(documentsDirectoryPath + "/testImageFileName.jpg")
                }
                
                it("should write the data to disk") {
                    let readDataPathName = documentsDirectoryPath.stringByAppendingString("/" + "testImageFileName.jpg")
                    
                    let storedImage = UIImage.init(contentsOfFile: readDataPathName)
                    expect(storedImage).toNot(beNil(), description: "Failed to store data in documents folder")
                }
            }
            
            describe("#writeImage(image:toFileWithName:)") {
                var image: UIImage?
                
                beforeEach {
                    image = UIImage(named:"testImage.jpg", inBundle: NSBundle(forClass: self.dynamicType), compatibleWithTraitCollection: nil)
                    subject.writeImage(image, toFileWithName: "testImageFileName.jpg")
                }
                
                afterEach {
                    try! NSFileManager.defaultManager().removeItemAtPath(documentsDirectoryPath + "/testImageFileName.jpg")
                }
                
                it("should write the image's data to disk") {
                    let readDataPathName = documentsDirectoryPath.stringByAppendingString("/" + "testImageFileName.jpg")
                    
                    let storedImage = UIImage.init(contentsOfFile: readDataPathName)
                    expect(storedImage).toNot(beNil(), description: "Failed to store image in documents folder")
                }
            }
        }
    }
}
