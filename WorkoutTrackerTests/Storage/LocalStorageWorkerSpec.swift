import Quick
import Nimble
import Swinject
@testable import WorkoutTracker

class LocalStorageWorkerSpec: QuickSpec {
    override func spec() {
        func deleteIfExists(fileOrDirectoryPath: String) {
            let exists = NSFileManager.defaultManager().fileExistsAtPath(fileOrDirectoryPath,
                                                                         isDirectory: nil)
            if exists {
                try! NSFileManager.defaultManager().removeItemAtPath(fileOrDirectoryPath)
            }
        }
        
        func clearAllFiles() {
            let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
            
            deleteIfExists(documentsDirectoryPath + "/testDictionary.json")
            deleteIfExists(documentsDirectoryPath + "/testImageFileName.jpg")
            deleteIfExists(documentsDirectoryPath + "/Subdirectory/testDictionary.json")
            deleteIfExists(documentsDirectoryPath + "/Subdirectory/testImageFileName.jpg")
            deleteIfExists(documentsDirectoryPath + "/Subdirectory")
            deleteIfExists(documentsDirectoryPath + "/testDeletionOne.jpg")
            deleteIfExists(documentsDirectoryPath + "/testDeletionTwo.jpg")
            deleteIfExists(documentsDirectoryPath + "/testDeletionThree.jpg")
            deleteIfExists(documentsDirectoryPath + "/testDeletionFour.png")
            deleteIfExists(documentsDirectoryPath + "/integrationTest.jpg")
            deleteIfExists(documentsDirectoryPath + "/integrationTest.json")
            
            deleteIfExists(documentsDirectoryPath + "/100.jpg")
            deleteIfExists(documentsDirectoryPath + "/200.jpg")
            deleteIfExists(documentsDirectoryPath + "/300.jpg")
            deleteIfExists(documentsDirectoryPath + "/400.txt")
            deleteIfExists(documentsDirectoryPath + "/DirectoryOne/500.txt")
            deleteIfExists(documentsDirectoryPath + "/DirectoryOne/600.txt")
            deleteIfExists(documentsDirectoryPath + "/DirectoryTwo/700.txt")
            deleteIfExists(documentsDirectoryPath + "/DirectoryTwo/800.jpg")
            deleteIfExists(documentsDirectoryPath + "/DirectoryTwo/900.txt")
            deleteIfExists(documentsDirectoryPath + "/DirectoryTwo/SubdirectoryOne/1000.txt")
            deleteIfExists(documentsDirectoryPath + "/DirectoryTwo/SubdirectoryOne/1100.jpg")
            
            deleteIfExists(documentsDirectoryPath + "/DirectoryTwo/SubdirectoryOne")
            deleteIfExists(documentsDirectoryPath + "/DirectoryTwo")
            deleteIfExists(documentsDirectoryPath + "/DirectoryOne")
        }
        
        describe("LocalStorageWorker") {
            var subject: LocalStorageWorker!
            var documentsDirectoryPath: String!
            
            beforeEach {
                let container = Container()
                LocalStorageWorker.registerForInjection(container)
                subject = container.resolve(LocalStorageWorker.self)
                documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
            }
            
            describe("Working with file system data") {
                describe("Attempting to create a directory") {
                    var result: Bool!
                    var directoryPath: String!
                    
                    beforeEach {
                        directoryPath = documentsDirectoryPath + "/Directory"
                        deleteIfExists(directoryPath)
                        result = subject.createDirectory("Directory")
                    }
                    
                    afterEach {
                        deleteIfExists(directoryPath)
                    }
                    
                    context("When the directory does not exist yet") {
                        it("creates a directory in the file system") {
                            let directoryExists = NSFileManager.defaultManager().fileExistsAtPath(directoryPath, isDirectory: nil)
                            expect(directoryExists).to(beTrue())
                        }
                        
                        it("returns true") {
                            expect(result).to(beTrue())
                        }
                        
                        context("When the directory already exists") {
                            beforeEach {
                                result = subject.createDirectory("Directory")
                            }
                            
                            it("returns false") {
                                expect(result).to(beFalse())
                            }
                        }
                    }
                }
                
                describe("Reading and writing data") {
                    var testImage: UIImage?
                    var testDictionary: [String : AnyObject]!
                    
                    beforeEach {
                        testImage = UIImage(named:"testImage.jpg", inBundle: NSBundle(forClass: self.dynamicType), compatibleWithTraitCollection: nil)
                        testDictionary = ["turtle one" : "turtle value", "turtle two" : 1000]
                    }
                    
                    afterEach {
                        clearAllFiles()
                    }
                    
                    it("should be able to save an image and fetch that same image back") {
                        try! subject.writeData(UIImageJPEGRepresentation(testImage!, 1.0), toFileWithName: "integrationTest.jpg")
                        let fetchedData = subject.readDataFromFile("integrationTest.jpg")
                        expect(fetchedData).to(equal(UIImageJPEGRepresentation(testImage!, 1.0)))
                    }
                    
                    it("should be able to save a dictionary and fetch that same dictionary back") {
                        try! subject.writeJSONDictionary(testDictionary, toFileWithName: "integrationTest.json")
                        let fetchedDictionary = try! subject.readJSONDictionaryFromFile("integrationTest.json")
                        
                        expect(fetchedDictionary?["turtle one"] as? String).to(equal("turtle value"))
                        expect(fetchedDictionary?["turtle two"] as? Int).to(equal(1000))
                    }
                }
                
                describe("Fetching file names") {
                    var fileNames: [String]!
                    
                    beforeEach {
                        clearAllFiles()
                        
                        let dataStringOne = "dolphins"
                        let dataStringTwo = "kittens"
                        let dataStringThree = "turtles"
                        let dataStringFour = "dogs"
                        
                        try! subject.writeData(dataStringOne.dataUsingEncoding(NSUTF8StringEncoding), toFileWithName: "100.jpg")
                        try! subject.writeData(dataStringTwo.dataUsingEncoding(NSUTF8StringEncoding), toFileWithName: "200.jpg")
                        try! subject.writeData(dataStringThree.dataUsingEncoding(NSUTF8StringEncoding), toFileWithName: "300.jpg")
                        try! subject.writeData(dataStringFour.dataUsingEncoding(NSUTF8StringEncoding), toFileWithName: "400.txt")
                        
                        subject.createDirectory("DirectoryOne")
                        
                        let dataStringFive = "antelopes"
                        let dataStringSix = "deer"
                        
                        try! subject.writeData(dataStringFive.dataUsingEncoding(NSUTF8StringEncoding), toFileWithName: "DirectoryOne/500.txt")
                        try! subject.writeData(dataStringSix.dataUsingEncoding(NSUTF8StringEncoding), toFileWithName: "DirectoryOne/600.txt")
                        
                        subject.createDirectory("DirectoryTwo")
                        
                        let dataStringSeven = "fish"
                        let dataStringEight = "bugs"
                        let dataStringNine = "people"
                        
                        try! subject.writeData(dataStringSeven.dataUsingEncoding(NSUTF8StringEncoding), toFileWithName: "DirectoryTwo/700.txt")
                        try! subject.writeData(dataStringEight.dataUsingEncoding(NSUTF8StringEncoding), toFileWithName: "DirectoryTwo/800.jpg")
                        try! subject.writeData(dataStringNine.dataUsingEncoding(NSUTF8StringEncoding), toFileWithName: "DirectoryTwo/900.txt")
                        
                        subject.createDirectory("DirectoryTwo/SubdirectoryOne")
                        
                        let dataStringTen = "coriander"
                        let dataStringEleven = "cumin"
                        
                        try! subject.writeData(dataStringTen.dataUsingEncoding(NSUTF8StringEncoding), toFileWithName: "DirectoryTwo/SubdirectoryOne/1000.txt")
                        try! subject.writeData(dataStringEleven.dataUsingEncoding(NSUTF8StringEncoding), toFileWithName: "DirectoryTwo/SubdirectoryOne/1100.jpg")
                    }
                    
                    afterEach {
                        clearAllFiles()
                    }
                    
                    context("Nonrecursive, with empty sting as the starting directory") {
                        beforeEach {
                            fileNames = subject.allFilesWithExtension("jpg", recursive: false,
                                startingDirectory: "")
                        }
                        
                        it("finds only the files at the top level with the given extension") {
                            expect(fileNames.count).to(equal(3))
                            expect(fileNames).to(contain("100.jpg"))
                            expect(fileNames).to(contain("200.jpg"))
                            expect(fileNames).to(contain("300.jpg"))
                        }
                    }
                    
                    context("Recursive, with empty string as the starting directory") {
                        beforeEach {
                            fileNames = subject.allFilesWithExtension("txt", recursive: true,
                                startingDirectory: "")
                        }
                        
                        it("finds the files all throughout the file system with the given extension") {
                            expect(fileNames.count).to(equal(6))
                            expect(fileNames).to(contain("400.txt"))
                            expect(fileNames).to(contain("DirectoryOne/500.txt"))
                            expect(fileNames).to(contain("DirectoryOne/600.txt"))
                            expect(fileNames).to(contain("DirectoryTwo/700.txt"))
                            expect(fileNames).to(contain("DirectoryTwo/900.txt"))
                            expect(fileNames).to(contain("DirectoryTwo/SubdirectoryOne/1000.txt"))
                        }
                    }
                    
                    context("Nonrecursive, with a directory given as the starting directory") {
                        beforeEach {
                            fileNames = subject.allFilesWithExtension("txt", recursive: false,
                                startingDirectory: "DirectoryTwo")
                        }
                        
                        it("finds the files only in the given directory with the given extension") {
                            expect(fileNames.count).to(equal(2))
                            expect(fileNames).to(contain("DirectoryTwo/700.txt"))
                            expect(fileNames).to(contain("DirectoryTwo/900.txt"))
                        }
                    }
                    
                    context("Recursive, with a directory given as the starting directory") {
                        beforeEach {
                            fileNames = subject.allFilesWithExtension("txt", recursive: true,
                                startingDirectory: "DirectoryTwo")
                        }
                        
                        it("finds the files in the given directory and its subdirectories with the given extension") {
                            expect(fileNames.count).to(equal(3))
                            expect(fileNames).to(contain("DirectoryTwo/700.txt"))
                            expect(fileNames).to(contain("DirectoryTwo/900.txt"))
                            expect(fileNames).to(contain("DirectoryTwo/SubdirectoryOne/1000.txt"))
                        }
                    }
                }
                
                describe("Deleting data") {
                    describe("Deleting individual files") {
                        var testData: NSData!
                        
                        beforeEach {
                            let dataString = "turtle power"
                            testData = dataString.dataUsingEncoding(NSUTF8StringEncoding)
                            try! subject.writeData(testData, toFileWithName: "testDeletion.jpg")
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
                        var testDataFive: NSData!
                        var testDataSix: NSData!
                        var testDataSeven: NSData!
                        var testDataEight: NSData!
                        var testDataNine: NSData!
                        var testDataTen: NSData!
                        var testDataEleven: NSData!
                        
                        beforeEach {
                            clearAllFiles()
                            
                            let dataStringOne = "dolphins"
                            testDataOne = dataStringOne.dataUsingEncoding(NSUTF8StringEncoding)
                            let dataStringTwo = "kittens"
                            testDataTwo = dataStringTwo.dataUsingEncoding(NSUTF8StringEncoding)
                            let dataStringThree = "turtles"
                            testDataThree = dataStringThree.dataUsingEncoding(NSUTF8StringEncoding)
                            let dataStringFour = "dogs"
                            testDataFour = dataStringFour.dataUsingEncoding(NSUTF8StringEncoding)
                            
                            try! subject.writeData(testDataOne, toFileWithName: "100.jpg")
                            try! subject.writeData(testDataTwo, toFileWithName: "200.jpg")
                            try! subject.writeData(testDataThree, toFileWithName: "300.jpg")
                            try! subject.writeData(testDataFour, toFileWithName: "400.txt")
                            
                            subject.createDirectory("DirectoryOne")
                            
                            let dataStringFive = "antelopes"
                            testDataFive = dataStringFive.dataUsingEncoding(NSUTF8StringEncoding)
                            let dataStringSix = "deer"
                            testDataSix = dataStringSix.dataUsingEncoding(NSUTF8StringEncoding)
                            
                            try! subject.writeData(testDataFive, toFileWithName: "DirectoryOne/500.txt")
                            try! subject.writeData(testDataSix, toFileWithName: "DirectoryOne/600.txt")
                            
                            subject.createDirectory("DirectoryTwo")
                            
                            let dataStringSeven = "fish"
                            testDataSeven = dataStringSeven.dataUsingEncoding(NSUTF8StringEncoding)
                            let dataStringEight = "bugs"
                            testDataEight = dataStringEight.dataUsingEncoding(NSUTF8StringEncoding)
                            let dataStringNine = "people"
                            testDataNine = dataStringNine.dataUsingEncoding(NSUTF8StringEncoding)
                            
                            try! subject.writeData(testDataSeven, toFileWithName: "DirectoryTwo/700.txt")
                            try! subject.writeData(testDataEight, toFileWithName: "DirectoryTwo/800.jpg")
                            try! subject.writeData(testDataNine, toFileWithName: "DirectoryTwo/900.txt")
                            
                            subject.createDirectory("DirectoryTwo/SubdirectoryOne")
                            
                            let dataStringTen = "coriander"
                            testDataTen = dataStringTen.dataUsingEncoding(NSUTF8StringEncoding)
                            let dataStringEleven = "cumin"
                            testDataEleven = dataStringEleven.dataUsingEncoding(NSUTF8StringEncoding)
                            
                            try! subject.writeData(testDataTen, toFileWithName: "DirectoryTwo/SubdirectoryOne/1000.txt")
                            try! subject.writeData(testDataEleven, toFileWithName: "DirectoryTwo/SubdirectoryOne/1100.jpg")
                        }
                        
                        afterEach {
                            clearAllFiles()
                        }
                        
                        context("Nonrecursive, with empty sting as the starting directory") {
                            beforeEach {
                                try! subject.deleteAllFilesWithExtension("jpg", recursive: false,
                                    startingDirectory: "")
                            }
                            
                            it("deletes only the files at the top level with the given extension") {
                                expect(subject.readDataFromFile("100.jpg")).to(beNil())
                                expect(subject.readDataFromFile("200.jpg")).to(beNil())
                                expect(subject.readDataFromFile("300.jpg")).to(beNil())
                                expect(subject.readDataFromFile("400.txt")).to(equal(testDataFour))
                            }
                        }
                        
                        context("Recursive, with empty string as the starting directory") {
                            beforeEach {
                                try! subject.deleteAllFilesWithExtension("txt", recursive: true,
                                    startingDirectory: "")
                            }
                            
                            it("finds the files all throughout the file system with the given extension") {
                                expect(subject.readDataFromFile("100.jpg")).to(equal(testDataOne))
                                expect(subject.readDataFromFile("400.txt")).to(beNil())
                                expect(subject.readDataFromFile("DirectoryOne/500.txt")).to(beNil())
                                expect(subject.readDataFromFile("DirectoryOne/600.txt")).to(beNil())
                                expect(subject.readDataFromFile("DirectoryOne/700.txt")).to(beNil())
                                expect(subject.readDataFromFile("DirectoryOne/900.txt")).to(beNil())
                                expect(subject.readDataFromFile("DirectoryTwo/SubdirectoryOne/1000.txt")).to(beNil())
                            }
                        }
                        
                        context("Nonrecursive, with a directory given as the starting directory") {
                            beforeEach {
                                try! subject.deleteAllFilesWithExtension("txt", recursive: false,
                                    startingDirectory: "DirectoryTwo")
                            }
                            
                            it("finds the files only in the given directory with the given extension") {
                                expect(subject.readDataFromFile("100.jpg")).to(equal(testDataOne))
                                expect(subject.readDataFromFile("400.txt")).to(equal(testDataFour))
                                expect(subject.readDataFromFile("DirectoryOne/700.txt")).to(beNil())
                                expect(subject.readDataFromFile("DirectoryOne/900.txt")).to(beNil())
                                expect(subject.readDataFromFile("DirectoryTwo/SubdirectoryOne/1000.txt")).to(equal(testDataTen))
                            }
                        }
                        
                        context("Recursive, with a directory given as the starting directory") {
                            beforeEach {
                                try! subject.deleteAllFilesWithExtension("txt", recursive: true,
                                    startingDirectory: "DirectoryTwo")
                            }
                            
                            it("finds the files in the given directory and its subdirectories with the given extension") {
                                expect(subject.readDataFromFile("100.jpg")).to(equal(testDataOne))
                                expect(subject.readDataFromFile("400.txt")).to(equal(testDataFour))
                                expect(subject.readDataFromFile("DirectoryOne/700.txt")).to(beNil())
                                expect(subject.readDataFromFile("DirectoryOne/900.txt")).to(beNil())
                                expect(subject.readDataFromFile("DirectoryTwo/SubdirectoryOne/1000.txt")).to(beNil())
                            }
                        }
                    }
                }
            }
            
            describe("#writeJSONDictionary(dictionary:toFileWithName:createsSubdirectories:)") {
                var dictionary: [String : AnyObject]!
                
                beforeEach {
                    dictionary = ["turtle example" : "turtle value", "turtle sample" : 567]
                }
                
                afterEach {
                    clearAllFiles()
                }
                
                context("When createSubdirectories is set to true") {
                    context("The directory already exists") {
                        beforeEach {
                            subject.createDirectory("Subdirectory")
                            try! subject.writeJSONDictionary(dictionary, toFileWithName: "Subdirectory/testDictionary.json",
                                createSubdirectories: true)
                        }
                        
                        it("should write the dictionary data to disk") {
                            let readDataPathName = documentsDirectoryPath.stringByAppendingString("/Subdirectory/" + "testDictionary.json")
                            
                            let storedData = NSData.init(contentsOfFile: readDataPathName)
                            expect(storedData).toNot(beNil(), description: "Failed to store data in documents folder")
                        }
                    }
                    
                    context("The directory doesn't exist yet") {
                        beforeEach {
                            try! subject.writeJSONDictionary(dictionary, toFileWithName: "Subdirectory/testDictionary.json",
                                createSubdirectories: true)
                        }
                        
                        it("should write the dictionary data to disk") {
                            let readDataPathName = documentsDirectoryPath.stringByAppendingString("/Subdirectory/" + "testDictionary.json")
                            
                            let storedData = NSData.init(contentsOfFile: readDataPathName)
                            expect(storedData).toNot(beNil(), description: "Failed to store data in documents folder")
                        }
                    }
                }
                
                context("When createSubdirectories is set to false") {
                    context("The directory already exists") {
                        beforeEach {
                            subject.createDirectory("Subdirectory")
                            try! subject.writeJSONDictionary(dictionary, toFileWithName: "Subdirectory/testDictionary.json",
                                createSubdirectories: false)
                        }
                        
                        it("should write the dictionary data to disk") {
                            let readDataPathName = documentsDirectoryPath.stringByAppendingString("/Subdirectory/" + "testDictionary.json")
                            
                            let storedData = NSData.init(contentsOfFile: readDataPathName)
                            expect(storedData).toNot(beNil(), description: "Failed to store data in documents folder")
                        }
                    }
                    
                    context("The directory doesn't exist yet") {
                        it("should throw an error and fail to write the file to disk") {
                            expect {
                                try subject.writeJSONDictionary(dictionary, toFileWithName: "Subdirectory/testDictionary.json",
                                    createSubdirectories: false)
                                }.to(throwError())
                            
                            let readDataPathName = documentsDirectoryPath.stringByAppendingString("/Subdirectory/" + "testDictionary.json")
                            let storedData = NSData.init(contentsOfFile: readDataPathName)
                            expect(storedData).to(beNil())
                        }
                    }
                }
            }
            
            describe("#writeData(data:toFileWithName:createsSubdirectories:)") {
                var image: UIImage?
                var imageData: NSData?
                
                beforeEach {
                    image = UIImage(named:"testImage.jpg", inBundle: NSBundle(forClass: self.dynamicType), compatibleWithTraitCollection: nil)
                    imageData = UIImageJPEGRepresentation(image!, 1.0)
                }
                
                afterEach {
                    clearAllFiles()
                }
                
                context("When createSubdirectories is set to true") {
                    context("The directory already exists") {
                        beforeEach {
                            subject.createDirectory("Subdirectory")
                            try! subject.writeData(imageData, toFileWithName: "Subdirectory/testImageFileName.jpg",
                                createSubdirectories: true)
                        }
                        
                        it("should write the data to disk") {
                            let readDataPathName = documentsDirectoryPath.stringByAppendingString("/Subdirectory/" + "testImageFileName.jpg")
                            
                            let storedImage = UIImage.init(contentsOfFile: readDataPathName)
                            expect(storedImage).toNot(beNil(), description: "Failed to store data in documents folder")
                        }
                    }
                    
                    context("The directory doesn't exist yet") {
                        beforeEach {
                            try! subject.writeData(imageData, toFileWithName: "Subdirectory/testImageFileName.jpg",
                                createSubdirectories: true)
                        }
                        
                        it("should write the data to disk") {
                            let readDataPathName = documentsDirectoryPath.stringByAppendingString("/Subdirectory/" + "testImageFileName.jpg")
                            
                            let storedImage = UIImage.init(contentsOfFile: readDataPathName)
                            expect(storedImage).toNot(beNil(), description: "Failed to store data in documents folder")
                        }
                    }
                }
                
                context("When createSubdirectories is set to false") {
                    context("The directory already exists") {
                        beforeEach {
                            subject.createDirectory("Subdirectory")
                            try! subject.writeData(imageData, toFileWithName: "Subdirectory/testImageFileName.jpg",
                                createSubdirectories: false)
                        }
                        
                        it("should write the data to disk") {
                            let readDataPathName = documentsDirectoryPath.stringByAppendingString("/Subdirectory/" + "testImageFileName.jpg")
                            
                            let storedImage = UIImage.init(contentsOfFile: readDataPathName)
                            expect(storedImage).toNot(beNil(), description: "Failed to store data in documents folder")
                        }
                    }
                    
                    context("The directory doesn't exist yet") {
                        it("should throw an error and fail to write the file to disk") {
                            expect {
                                try subject.writeData(imageData, toFileWithName: "Subdirectory/testImageFileName.jpg",
                                    createSubdirectories: false)
                                }.to(throwError())
                            
                            let readDataPathName = documentsDirectoryPath.stringByAppendingString("/Subdirectory/" + "testImageFileName.jpg")
                            let storedImage = UIImage.init(contentsOfFile: readDataPathName)
                            expect(storedImage).to(beNil())
                        }
                    }
                }
            }
            
            describe("#writeImage(image:toFileWithName:createsSubdirectories:)") {
                var image: UIImage?
                
                beforeEach {
                    image = UIImage(named:"testImage.jpg", inBundle: NSBundle(forClass: self.dynamicType), compatibleWithTraitCollection: nil)
                }
                
                afterEach {
                    clearAllFiles()
                }
                
                context("When createSubdirectories is set to true") {
                    context("The directory already exists") {
                        beforeEach {
                            subject.createDirectory("Subdirectory")
                            try! subject.writeImage(image, toFileWithName: "Subdirectory/testImageFileName.jpg",
                                createSubdirectories: true)
                        }
                        
                        it("should write the data to disk") {
                            let readDataPathName = documentsDirectoryPath.stringByAppendingString("/Subdirectory/" + "testImageFileName.jpg")
                            
                            let storedImage = UIImage.init(contentsOfFile: readDataPathName)
                            expect(storedImage).toNot(beNil(), description: "Failed to store data in documents folder")
                        }
                    }
                    
                    context("The directory doesn't exist yet") {
                        beforeEach {
                            try! subject.writeImage(image, toFileWithName: "Subdirectory/testImageFileName.jpg",
                                createSubdirectories: true)
                        }
                        
                        it("should write the data to disk") {
                            let readDataPathName = documentsDirectoryPath.stringByAppendingString("/Subdirectory/" + "testImageFileName.jpg")
                            
                            let storedImage = UIImage.init(contentsOfFile: readDataPathName)
                            expect(storedImage).toNot(beNil(), description: "Failed to store data in documents folder")
                        }
                    }
                }
                
                context("When createSubdirectories is set to false") {
                    context("The directory already exists") {
                        beforeEach {
                            subject.createDirectory("Subdirectory")
                            try! subject.writeImage(image, toFileWithName: "Subdirectory/testImageFileName.jpg",
                                createSubdirectories: false)
                        }
                        
                        it("should write the data to disk") {
                            let readDataPathName = documentsDirectoryPath.stringByAppendingString("/Subdirectory/" + "testImageFileName.jpg")
                            
                            let storedImage = UIImage.init(contentsOfFile: readDataPathName)
                            expect(storedImage).toNot(beNil(), description: "Failed to store data in documents folder")
                        }
                    }
                    
                    context("The directory doesn't exist yet") {
                        it("should throw an error and fail to write the file to disk") {
                            expect {
                                try subject.writeImage(image, toFileWithName: "Subdirectory/testImageFileName.jpg",
                                    createSubdirectories: false)
                                }.to(throwError())
                            
                            let readDataPathName = documentsDirectoryPath.stringByAppendingString("/Subdirectory/" + "testImageFileName.jpg")
                            let storedImage = UIImage.init(contentsOfFile: readDataPathName)
                            expect(storedImage).to(beNil())
                        }
                    }
                }
            }
        }
    }
    
}
