import Quick
import Nimble
import WorkoutTracker

class LiftSetTableViewCellSpec: QuickSpec {
    override func spec() {
        describe("LiftSetTableViewCell") {
            var subject: LiftSetTableViewCell!
            
            beforeEach {
                let tableView = UITableView()
                tableView.registerNib(UINib(nibName: LiftSetTableViewCell.name, bundle:nil), forCellReuseIdentifier: LiftSetTableViewCell.name)
                subject = tableView.dequeueReusableCellWithIdentifier(LiftSetTableViewCell.name)
                    as! LiftSetTableViewCell
            }
            
            describe("Preparing for reuse") {
                var setOne: LiftSet!
                var setTwo: LiftSet!
                
                beforeEach {
                    setOne = LiftSet(withDataTemplate: .WeightReps, data: ["weight": 100, "reps": 9])
                    subject.configureWithSet(setOne)
                    
                    subject.prepareForReuse()
                    
                    setTwo = LiftSet(withDataTemplate: .WeightReps, data: ["weight": 200, "reps": 10])
                    subject.configureWithSet(setTwo)
                }
                
                it("will only have subviews from the second configure run") {
                    expect(subject.columnStackView?.arrangedSubviews.count).to(equal(2))
                }
            }
            
            describe("Configuring with a set") {
                var set: LiftSet?
                
                describe("Treatment of the set model") {
                    beforeEach {
                        set = LiftSet(withDataTemplate: .WeightReps, data: ["":""])
                        subject.configureWithSet(set!)
                    }
                    
                    it("sets the given set as its set 😝") {
                        expect(subject.set).to(beIdenticalTo(set))
                    }
                }
                
                describe("Laying out its view") {
                    context("With a Weight/Reps set") {
                        beforeEach {
                            set = LiftSet(withDataTemplate: .WeightReps, data: ["weight": 123, "reps": 9])
                            subject.configureWithSet(set!)
                        }
                        
                        it("should distribute its stack view evenly") {
                            expect(subject.columnStackView?.distribution).to(equal(UIStackViewDistribution.FillEqually))
                        }
                        
                        describe("The cell's columnized subviews") {
                            it("should have two") {
                                expect(subject.columnStackView?.arrangedSubviews.count).to(equal(2))
                            }
                            
                            var subview: LiftTableViewCellColumnView?
                            
                            describe("The first subview") {
                                beforeEach {
                                    subview = subject.columnStackView?.arrangedSubviews[0] as? LiftTableViewCellColumnView
                                }
                                
                                it("sets weight's value as its label") {
                                    expect(subview?.textLabel?.text).to(equal("123.0"))
                                }
                            }
                            
                            describe("The second subview") {
                                beforeEach {
                                    subview = subject.columnStackView?.arrangedSubviews[1] as? LiftTableViewCellColumnView
                                }
                                
                                it("sets reps's value as its label") {
                                    expect(subview?.textLabel?.text).to(equal("9"))
                                }
                            }
                        }
                    }
                    
                    context("With a Height/Reps set") {
                        beforeEach {
                            set = LiftSet(withDataTemplate: .HeightReps, data: ["height": 42, "reps": 5])
                            subject.configureWithSet(set!)
                        }
                        
                        it("should distribute its stack view evenly") {
                            expect(subject.columnStackView?.distribution).to(equal(UIStackViewDistribution.FillEqually))
                        }
                        
                        describe("The cell's columnized subviews") {
                            it("should have two") {
                                expect(subject.columnStackView?.arrangedSubviews.count).to(equal(2))
                            }
                            
                            var subview: LiftTableViewCellColumnView?
                            
                            describe("The first subview") {
                                beforeEach {
                                    subview = subject.columnStackView?.arrangedSubviews[0] as? LiftTableViewCellColumnView
                                }
                                
                                it("sets height's value as its label") {
                                    expect(subview?.textLabel?.text).to(equal("42.0"))
                                }
                            }
                            
                            describe("The second subview") {
                                beforeEach {
                                    subview = subject.columnStackView?.arrangedSubviews[1] as? LiftTableViewCellColumnView
                                }
                                
                                it("sets reps's value as its label") {
                                    expect(subview?.textLabel?.text).to(equal("5"))
                                }
                            }
                        }
                    }
                    
                    context("With a Time(sec) set") {
                        beforeEach {
                            set = LiftSet(withDataTemplate: .TimeInSeconds, data: ["time(sec)": 55])
                            subject.configureWithSet(set!)
                        }
                        
                        it("should distribute its stack view evenly") {
                            expect(subject.columnStackView?.distribution).to(equal(UIStackViewDistribution.FillEqually))
                        }
                        
                        describe("The cell's columnized subviews") {
                            it("should have one") {
                                expect(subject.columnStackView?.arrangedSubviews.count).to(equal(1))
                            }
                            
                            var subview: LiftTableViewCellColumnView?
                            
                            describe("The first subview") {
                                beforeEach {
                                    subview = subject.columnStackView?.arrangedSubviews[0] as? LiftTableViewCellColumnView
                                }
                                
                                it("sets time(sec)'s value as its label") {
                                    expect(subview?.textLabel?.text).to(equal("55.0"))
                                }
                            }
                        }
                    }
                    
                    context("With a Weight/Time(sec) set") {
                        beforeEach {
                            set = LiftSet(withDataTemplate: .WeightTimeInSeconds, data: ["weight": 123, "time(sec)": 35])
                            subject.configureWithSet(set!)
                        }
                        
                        it("should distribute its stack view evenly") {
                            expect(subject.columnStackView?.distribution).to(equal(UIStackViewDistribution.FillEqually))
                        }
                        
                        describe("The cell's columnized subviews") {
                            it("should have two") {
                                expect(subject.columnStackView?.arrangedSubviews.count).to(equal(2))
                            }
                            
                            var subview: LiftTableViewCellColumnView?
                            
                            describe("The first subview") {
                                beforeEach {
                                    subview = subject.columnStackView?.arrangedSubviews[0] as? LiftTableViewCellColumnView
                                }
                                
                                it("sets weight's value as its label") {
                                    expect(subview?.textLabel?.text).to(equal("123.0"))
                                }
                            }
                            
                            describe("The second subview") {
                                beforeEach {
                                    subview = subject.columnStackView?.arrangedSubviews[1] as? LiftTableViewCellColumnView
                                }
                                
                                it("sets time(sec)'s value as its label") {
                                    expect(subview?.textLabel?.text).to(equal("35.0"))
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
