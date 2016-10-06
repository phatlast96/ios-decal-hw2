//
//  ViewController.swift
//  SwiftCalc
//
//  Created by Zach Zeleznick on 9/20/16.
//  Copyright © 2016 zzeleznick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Width and Height of Screen for Layout
    var w: CGFloat!
    var h: CGFloat!
    

    // IMPORTANT: Do NOT modify the name or class of resultLabel.
    //            We will be using the result label to run autograded tests.
    // MARK: The label to display our calculations
    var resultLabel = UILabel()
    
    // TODO: This looks like a good place to add some data structures.
    //       One data structure is initialized below for reference.
    var someDataStructure: [String] = [""]
    
    // A variable that indicates whether the resultLabel needs to be reset.
    var needToResetResultLabel = true

    override func viewDidLoad() {
        super.viewDidLoad()
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        w = view.bounds.size.width
        h = view.bounds.size.height
        navigationItem.title = "Calculator"
        // IMPORTANT: Do NOT modify the accessibilityValue of resultLabel.
        //            We will be using the result label to run autograded tests.
        resultLabel.accessibilityValue = "resultLabel"
        makeButtons()
        // Do any additional setup here.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TODO: A method to update your data structure(s) would be nice.
    //       Modify this one or create your own.
    func updateSomeDataStructure(_ content: String) {
        print("Update me like one of those PCs")
        if (content == "*" || content == "/" || content == "-" || content == "+") &&
            (someDataStructure.last == "*" || someDataStructure.last == "/" || someDataStructure.last == "-" || someDataStructure.last == "+") {
            someDataStructure.removeLast()
        }
        if let emptyStringLocation = someDataStructure.index(of: "") {
            someDataStructure.remove(at: emptyStringLocation)
            
        }
        someDataStructure.append(content)
    }
    
    func wipeMemoryClean() {
        someDataStructure = []
    }
    
    // TODO: Ensure that resultLabel gets updated.
    //       Modify this one or create your own.
    func updateResultLabel(_ content: String) {
        print("Update me like one of those PCs")
        let isAlreadyDecimal = resultLabel.text!.contains(".")
        let isImplementingDecimal = content.contains(".")
        if NSString.init(string: resultLabel.text!).length == 7 && !needToResetResultLabel {
            return
        }
        if isAlreadyDecimal && isImplementingDecimal && !needToResetResultLabel {
            return
        }
        if needToResetResultLabel {
            resultLabel.text = content
            needToResetResultLabel = false
        } else {
            resultLabel.text! += content
        }
        
    }
    
    
    // TODO: A calculate method with no parameters, scary!
    //       Modify this one or create your own.
    func calculate() -> String {
        if someDataStructure.count <= 1 {
            return resultLabel.text!
        }
        updateSomeDataStructure(resultLabel.text!)
        let firstParameter = someDataStructure.removeFirst()
        let binaryOperator = someDataStructure.removeFirst()
        let secondParameter = someDataStructure.removeFirst()
        var result = "\(calculate(a: firstParameter, b: secondParameter, operation: binaryOperator))"
        
        if result.hasSuffix(".0") {
            let resultArray = result.components(separatedBy: ".")
            result = resultArray[0]
        }
        return result
    }
    
    // TODO: A simple calculate method for integers.
    //       Modify this one or create your own.
    func intCalculate(a: Int, b:Int, operation: String) -> Int {
        print("Calculation requested for \(a) \(operation) \(b)")
        switch operation {
            case "/":
                return a / b
            case "*":
                return a * b
            case "+":
                return a + b
            case "-":
                return a - b
        default: break
        }
        return 0
    }
    
    // TODO: A general calculate method for doubles
    //       Modify this one or create your own.
    func calculate(a: String, b:String, operation: String) -> Double {
        
        print("Calculation requested for \(a) \(operation) \(b)")
        if let m = Double.init(a) {
            if let n = Double.init(b) {
                switch operation {
                case "/":
                    return m / n
                case "*":
                    return m * n
                case "+":
                    return m + n
                case "-":
                    return m - n
                default: break
                }
            }
        }
        return 0
    }
    
    // REQUIRED: The responder to a number button being pressed.
    func numberPressed(_ sender: CustomButton) {
        guard Int(sender.content) != nil else { return }
        print("The number \(sender.content) was pressed")
        // Fill me in!
        updateResultLabel(sender.content)
    }
    
    // REQUIRED: The responder to an operator button being pressed.
    func operatorPressed(_ sender: CustomButton) {
        // Fill me in!
        switch sender.content {
            case "C":
                needToResetResultLabel = true
                updateResultLabel("0")
                needToResetResultLabel = true
            case "+/-":
                let isNegative = resultLabel.text!.contains("-")
                let isZero = resultLabel.text! == "0"
                if isNegative && !isZero {
                    resultLabel.text!.remove(at: resultLabel.text!.startIndex)
                } else if !isNegative && !isZero {
                    needToResetResultLabel = true
                    updateResultLabel("-" + resultLabel.text!)
                }
            case "%":
                var textDisplayed = resultLabel.text!
                if textDisplayed.characters.count == 1 && !textDisplayed.contains("-") && textDisplayed != "0" {
                    resultLabel.text = "0.0" + textDisplayed
                } else if textDisplayed.characters.count == 2 && !textDisplayed.contains("-") {
                    resultLabel.text = "0." + textDisplayed
                } else {
                    let decimalPosition = textDisplayed.index(textDisplayed.endIndex, offsetBy: -2)
                    resultLabel.text!.characters.insert(".", at: decimalPosition)
                }
                
                pressEnter()
            case "/":
                binaryOperatorPressed(operation: "/")
            case "*":
                binaryOperatorPressed(operation: "*")
            case "-":
                binaryOperatorPressed(operation: "-")
            case "+":
                binaryOperatorPressed(operation: "+")
            case "=":
                pressEnter()
        default: break
        }
        
        print("Operator \(sender.content) was pressed. Current data structure is \(someDataStructure)")
    }
    
    private var isPrevOperationEnter = false
    private func binaryOperatorPressed(operation op: String) {
        if needToResetResultLabel && !isPrevOperationEnter {
            updateSomeDataStructure(op)
            return
        }
        pressEnter()
        isPrevOperationEnter = false
        updateSomeDataStructure(resultLabel.text!)
        updateSomeDataStructure(op)
        needToResetResultLabel = true
    }
    
    private func pressEnter() {
        needToResetResultLabel = true
        updateResultLabel(calculate())
        needToResetResultLabel = true
        isPrevOperationEnter = true
    }
    
    // REQUIRED: The responder to a number or operator button being pressed.
    func buttonPressed(_ sender: CustomButton) {
       // Fill me in!
        print("Button \(sender.content) was pressed")
        switch sender.content {
            case "0":
                updateResultLabel("0")
            case ".":
                if resultLabel.text! == "0" {
                    needToResetResultLabel = false
                }
                updateResultLabel(".")
        default: break
        }
    }
    
    // IMPORTANT: Do NOT change any of the code below.
    //            We will be using these buttons to run autograded tests.
    
    func makeButtons() {
        // MARK: Adds buttons
        let digits = (1..<10).map({
            return String($0)
        })
        let operators = ["/", "*", "-", "+", "="]
        let others = ["C", "+/-", "%"]
        let special = ["0", "."]
        
        let displayContainer = UIView()
        view.addUIElement(displayContainer, frame: CGRect(x: 0, y: 0, width: w, height: 160)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.black
        }
        displayContainer.addUIElement(resultLabel, text: "0", frame: CGRect(x: 70, y: 70, width: w-70, height: 90)) {
            element in
            guard let label = element as? UILabel else { return }
            label.textColor = UIColor.white
            label.font = UIFont(name: label.font.fontName, size: 60)
            label.textAlignment = NSTextAlignment.right
        }
        
        let calcContainer = UIView()
        view.addUIElement(calcContainer, frame: CGRect(x: 0, y: 160, width: w, height: h-160)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.black
        }

        let margin: CGFloat = 1.0
        let buttonWidth: CGFloat = w / 4.0
        let buttonHeight: CGFloat = 100.0
        
        // MARK: Top Row
        for (i, el) in others.enumerated() {
            let x = (CGFloat(i%3) + 1.0) * margin + (CGFloat(i%3) * buttonWidth)
            let y = (CGFloat(i/3) + 1.0) * margin + (CGFloat(i/3) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(operatorPressed), for: .touchUpInside)
            }
        }
        // MARK: Second Row 3x3
        for (i, digit) in digits.enumerated() {
            let x = (CGFloat(i%3) + 1.0) * margin + (CGFloat(i%3) * buttonWidth)
            let y = (CGFloat(i/3) + 1.0) * margin + (CGFloat(i/3) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: digit), text: digit,
            frame: CGRect(x: x, y: y+101.0, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(numberPressed), for: .touchUpInside)
            }
        }
        // MARK: Vertical Column of Operators
        for (i, el) in operators.enumerated() {
            let x = (CGFloat(3) + 1.0) * margin + (CGFloat(3) * buttonWidth)
            let y = (CGFloat(i) + 1.0) * margin + (CGFloat(i) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.backgroundColor = UIColor.orange
                button.setTitleColor(UIColor.white, for: .normal)
                button.addTarget(self, action: #selector(operatorPressed), for: .touchUpInside)
            }
        }
        // MARK: Last Row for big 0 and .
        for (i, el) in special.enumerated() {
            let myWidth = buttonWidth * (CGFloat((i+1)%2) + 1.0) + margin * (CGFloat((i+1)%2))
            let x = (CGFloat(2*i) + 1.0) * margin + buttonWidth * (CGFloat(i*2))
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: 405, width: myWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            }
        }
    }

}

