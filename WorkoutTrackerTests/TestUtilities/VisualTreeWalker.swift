import UIKit
import Quick
import Nimble

class VisualTreeWalker {
    class func findAllSubviewsOfType<T: UIView>(subviewType: T.Type, rootVisual: UIView) -> [UIView] {
        var subviews = [UIView]()
        for subview in rootVisual.subviews {
            if let castedSubview = subview as? T {
                subviews.append(castedSubview)
            }
            
            subviews.appendContentsOf(findAllSubviewsOfType(subviewType, rootVisual: subview))
        }
        
        return subviews
    }
    
    class func findAllSubviewsOfType<T: UIView>(subviewType: T.Type, conformingToBlock predicateBlock: (T) -> Bool, rootVisual: UIView) -> [UIView] {
        var subviews = [UIView]()
        for subview in rootVisual.subviews {
            if let castedSubview = subview as? T {
                if predicateBlock(castedSubview) {
                    subviews.append(castedSubview)
                }
            }
            
            subviews.appendContentsOf(findAllSubviewsOfType(subviewType, conformingToBlock: predicateBlock, rootVisual: subview))
        }
        
        return subviews
    }
}

class VisualTreeWalkerSpec: QuickSpec {
    override func spec() {
        describe("VisualTreeWalker") {
            var rootView: UIView!
            var viewOne: UIView!
            var viewTwo: UIView!
            var viewThree: UIView!
            var rabbitTitleButtonOne: UIButton!
            var rabbitTitleButtonTwo: UIButton!
            
            beforeEach {
                rootView = UIView()
                
                viewOne = UIView()
                viewOne.addSubview(UIButton())
                viewOne.addSubview(UIButton())
                viewOne.addSubview(UITextField())
                rabbitTitleButtonOne = UIButton()
                rabbitTitleButtonOne.titleLabel!.text = "Rabbit"
                viewOne.addSubview(rabbitTitleButtonOne)
                
                rootView.addSubview(viewOne)
                
                viewTwo = UIView()
                viewTwo.addSubview(UISwitch())
                
                viewThree = UIView()
                viewThree.addSubview(UIButton())
                viewThree.addSubview(UIView())
                viewThree.addSubview(UITextField())
                rabbitTitleButtonTwo = UIButton()
                rabbitTitleButtonTwo.titleLabel!.text = "Rabbit"
                viewThree.addSubview(rabbitTitleButtonTwo)
                
                viewTwo.addSubview(viewThree)
                
                rootView.addSubview(viewTwo)
            }
            
            it("should return all the subviews that match a given type") {
                expect(VisualTreeWalker.findAllSubviewsOfType(UITextField.self, rootVisual: rootView).count).to(equal(2))
            }
            
            it("should return all the subviews that conform to a given predicate block") {
                let rabbitButtons = VisualTreeWalker.findAllSubviewsOfType(UIButton.self, conformingToBlock: { (button: UIButton) -> Bool in
                        return button.titleLabel?.text == "Rabbit"
                    },
                    rootVisual: rootView)
                expect(rabbitButtons.count).to(equal(2))
                expect(rabbitButtons[0]).to(beIdenticalTo(rabbitTitleButtonOne))
                expect(rabbitButtons[1]).to(beIdenticalTo(rabbitTitleButtonTwo))
            }
        }
    }
}
