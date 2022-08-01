//
//  ViewController.swift
//  testCalculator
//
//  Created by Thanaphat Thanawatpanya on 22/7/2565 BE.
//

import UIKit

/** Declare value of function **/
var firstNumber: Number = Number()
var secondNumber: Number = Number()
var selectedOperation: Operation!
var selectedPosition: Position = Position.first
var pressEqualButtonBefore: Bool = false

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    /** Declare value of element UI and action function **/
    @IBOutlet var numberButtons: [UIButton]!
    @IBOutlet var mainOperationButtons: [UIButton]!
    @IBOutlet weak var outputAnswer: UILabel!
    @IBAction func pressNumberButton(_ sender: UIButton) {
        /** Check if press equal button before **/
        if pressEqualButtonBefore {
            print("User press equal button before press number button then set selected number to first number for new equation.")
            /** Set first number value to blank,  selected position to first number for new equation and set pressEqualButtonBefore to false **/
            firstNumber.deleteValue()
            selectedPosition = .first
            pressEqualButtonBefore = false
        }
        
        /** Get value of Button **/
        let inputValue: String = getValueOfButton(button: sender)
        print("Recieved number input : \(inputValue) | ", terminator: "")
        
        /** Check and select collect number by position then output **/
        switch selectedPosition {
        case .first:
            print("Set to first number")
            firstNumber.collectValue(input: inputValue)
            setOutput(output: firstNumber.outputValue!)
        case .second:
            print("Set to second number")
            secondNumber.collectValue(input: inputValue)
            setOutput(output: secondNumber.outputValue!)
        }
        
        /** Debugging main value **/
        debuggingMainValue()
    }

    @IBAction func pressOperationButton(_ sender: UIButton) {
        /** Get value of Button **/
        let operateSelected: String = getValueOfButton(button: sender)
        
        /** Set previous selected button to unhighlighted **/
        setUnHightlightedOperationButton()
        
        /** Check if press equal button before **/
        if pressEqualButtonBefore {
            print("User press equal button before press operation button then all value still same value.")
            /** Set pressEqualButtonBefore to false **/
            pressEqualButtonBefore = false
        }
        
        /** Check and select operation and calculate **/
        switch operateSelected {
        case "+":
            print("Press : +")
            
            /** Check value exist of first number, second number and selected operation for calculate last equation or skip **/
            checkSkipOrCalculate()
            
            /** Set new selected operation to plus **/
            selectedOperation = .plus
            print("Set selected operation to plus")
        case "-":
            print("Press : -")
            
            /** Check value exist of first number, second number and selected operation for calculate last equation or skip **/
            checkSkipOrCalculate()
            
            /** Set new selected operation to minus **/
            selectedOperation = .minus
            print("Set selected operation to minus")
        case "x":
            print("Press : x")
            
            /** Check value exist of first number, second number and selected operation for calculate last equation or skip **/
            checkSkipOrCalculate()
            
            /** Set new selected operation to multiply **/
            selectedOperation = .multiply
            print("Set selected operation to multiply")
        case "÷":
            print("Press : ÷")
            
            /** Check value exist of first number, second number and selected operation for calculate last equation or skip **/
            checkSkipOrCalculate()
            
            /** Set new selected operation to divide **/
            selectedOperation = .divide
            print("Set selected operation to divide")
        case "=":
            print("Press : =")
            
            /** Set status of press equal button is true for operate different case in the future **/
            pressEqualButtonBefore = true
            
            /** Check value exist of first number, second number and selected operation for calculate last equation or skip **/
            checkSkipOrCalculate()
        
            /** Set new selected operation to nil **/
            selectedOperation = nil
            print("Set selected operation to blank")
        default:
            /** Don't operate everything and output error **/
            setOutput(output: "Error")
            return
        }
        
        /** Switch receive input to second number **/
        selectedPosition = .second
        print("Switch receive input to second number")
        
        /** Set selected button to highlighted except equal operation **/
        if operateSelected != "=" { setHightlightedOperationButton(button: sender) }
        
        /** Debugging main value **/
        debuggingMainValue()
    }
    
    @IBAction func pressSecondaryOperationButton(_ sender: UIButton) {
        /** Get value of Button **/
        let operateSelected: String = getValueOfButton(button: sender)
        
        /** Set selected number **/
        var selectedNumber: Number
        /** Check press equal button before because when equation success, last answer will be to first number and receiver will be to second number -> set operate number to first number **/
        if pressEqualButtonBefore {
            selectedNumber = firstNumber
        } else {
            /** Set selected number by selected position **/
            switch selectedPosition {
            case .first:
                selectedNumber = firstNumber
            case .second:
                selectedNumber = secondNumber
            }
        }
        
        /** Check if selected number is blank then set value to 0 **/
        if selectedNumber.rawValue == nil { selectedNumber.collectValue(input: "0") }
        
        /** Check and select operation and calculate **/
        switch operateSelected {
        case "+/-":
            print("Press : +/-")
            
            secondaryCalculate(selectedNumber, operate: SecondaryOperation.convertPositiveNegative)
        case "%" :
            print("Press : %")
            
            secondaryCalculate(selectedNumber, operate: SecondaryOperation.percent)
        case ".":
            print("Press : .")
            
            secondaryCalculate(selectedNumber, operate: SecondaryOperation.dot)
        default:
            setOutput(output: "Error")
        }
        
        /** Set output answer **/
        setOutput(output: selectedNumber.outputValue!)
        
        /** Debugging main value **/
        debuggingMainValue()
    }

    @IBAction func pressDeleteButton(_ sender: UIButton) {
        print("Press : AC")
        
        /** Check select position of selected number for operate different case **/
        switch selectedPosition {
        case .first:
            /** Delete first number value & selected operation **/
            firstNumber.deleteValue()
            selectedOperation = nil
        case .second:
            /** Check if second number have value **/
            if let _ = secondNumber.rawValue, secondNumber.rawValue != 0 {
                /** Set second number value to 0 **/
                secondNumber.deleteValue()
                secondNumber.collectValue(input: "0")
            } else {
                /** Set all number value & selected operation to blank **/
                firstNumber.deleteValue()
                secondNumber.deleteValue()
                selectedOperation = nil
                
                /** Set unhighlight selected operation button **/
                setUnHightlightedOperationButton()
                
                /** Set selected position to first number **/
                selectedPosition = .first
            }
        }
        
        /** Set output to "0" and unhighlight selected operation button **/
        setOutput(output: "0")
        
        /** Debugging main value **/
        debuggingMainValue()
    }
    
    func getValueOfButton(button: UIButton) -> String {
        button.titleLabel?.text ?? ""
    }
    
    func setOutput(output: String) {
        outputAnswer.text = output
    }
    
    func debuggingMainValue () {
        print("\n***** Main Value Debugging *****")

        /** Debug first number value **/
        if let first = firstNumber.rawValue {
            print("First number : \(first)", terminator: "")
        } else {
            print("First number : <blank>", terminator: "")
        }
        
        /** Debug  second number value **/
        if let second = secondNumber.rawValue {
            print(" | Second Number : \(second)", terminator: "")
        } else {
            print(" | Second Number : <blank>", terminator: "")
        }
        
        /** Debug  selected operation **/
        if let operate = selectedOperation {
            print(" | Operation : \(operate)", terminator: "")
        } else {
            print(" | Operation : <blank>", terminator: "")
        }
        
        /** Debug  selected number for input **/
        switch selectedPosition {
        case .first:
            print(" | Selected number for input : first number")
        case .second:
            print(" | Selected number for input : second number")
        }
        
        print("********************************\n")
    }
    
    func checkSkipOrCalculate () {
        /** Check value exist of first number and set first number value to 0 **/
        if firstNumber.rawValue == nil { firstNumber.collectValue(input: "0")}
        
        /** Check value exist of selected operation **/
        if let operation = selectedOperation {
            /** Check value exist of second number and set second number value to "0" if press "="  **/
            if secondNumber.rawValue == nil && pressEqualButtonBefore { secondNumber = firstNumber }
            
            /** Calculate if all number have value */
            if firstNumber.rawValue != nil && secondNumber.rawValue != nil {
                /** Calculate lastest equation **/
                mainCalculate(firstNumber, secondNumber, operate: operation)
                
                /** Set second number to blank value for prepare receive input after calculate last equation **/
                secondNumber = Number()
                
                /** Set output answer **/
                setOutput(output: firstNumber.outputValue!)
            }
        }
    }
    
    func mainCalculate (_ firstNumber: Number = Number(), _ secondNumber: Number = Number(), operate: Operation) {
        /** Check operation and calculate then set answer to first number raw value **/
        switch operate {
        case .plus:
            firstNumber.rawValue += secondNumber.rawValue
        case .minus:
            firstNumber.rawValue -= secondNumber.rawValue
        case .multiply:
            firstNumber.rawValue *= secondNumber.rawValue
        case .divide:
            firstNumber.rawValue /= secondNumber.rawValue
        }
        
        /** Set output value  **/
        firstNumber.outputValue = String(firstNumber.rawValue)
        
        /** Validate output (Case : Number have .0) ->  Delete .0 of output **/
        if firstNumber.outputValue != nil && firstNumber.outputValue.hasSuffix(".0") {
            firstNumber.outputValue.removeLast()
            firstNumber.outputValue.removeLast()
        }
    }
    
    func secondaryCalculate (_ number: Number = Number(), operate: SecondaryOperation) {
        /** Check operation and calculate then set answer to selected number raw value except dot operation **/
        var stillDot: Bool = false
        var stillDotZero: Bool = false
        switch operate {
        case .convertPositiveNegative:
            number.rawValue = -(number.rawValue)
            
            /** Set still dot if output before operate have "." at last character **/
            stillDot = number.outputValue.hasSuffix(".") ? true : false
            
            /** Set still dot if output before operate have .0 at last character (User press "0" before) **/
            stillDotZero = number.outputValue.hasSuffix(".0") ? true : false
        case .percent:
            number.rawValue *= (1/100)
        case .dot:
            /** Set new output value only because raw value still have floating point **/
            number.outputValue += !number.outputValue.contains(".") ? "." : ""
            
            /** Set still dot **/
            stillDot = number.outputValue.hasSuffix(".") ? true : false
        }
        
        /** Set output value -> output always receive floating point **/
        number.outputValue = String(number.rawValue)
        
        /** Validate output **/
        /** Delete last character ("0")  if last output have last character "."  (e.g "7.")  **/
        if stillDot { number.outputValue.removeLast() }
        /** Delete last character (".0")  if new output have last character ".0"  (e.g "7.0")  **/
        if !stillDotZero {
            if number.outputValue.hasSuffix(".0") {
                number.outputValue.removeLast()
                number.outputValue.removeLast()
            }
        }
    }
    
    func setHightlightedOperationButton (button: UIButton) {
        setButtonByConfig(button: button, colorButton: UIColor.white, colorText: UIColor.systemOrange)
    }
    
    func setUnHightlightedOperationButton () {
        for button in mainOperationButtons {
            setButtonByConfig(button: button, colorButton: UIColor.systemOrange, colorText: UIColor.white)
        }
    }
    
    func setButtonByConfig (button: UIButton, colorButton: UIColor, colorText: UIColor) {
        button.backgroundColor = colorButton
        button.setTitleColor(colorText, for: .normal)
    }
}

class Number {
    var rawValue: Double!
    var outputValue: String!
    
    func collectValue (input: String) {
        /** Check value exist for add more or add first value of output value **/
        if let output = self.outputValue {
            /** Add input to last position of value but if output is "0" or "-0", it will set output to input **/
            self.outputValue = output == "0" || output == "-0" ? output.replacingOccurrences(of: "0", with: input) : output + input
        } else {
            /** Set output to input **/
            self.outputValue = input
        }
        
        /** Copy output value and convert to double for raw value **/
        self.rawValue = Double(self.outputValue)!
    }
    
    func deleteValue () {
        /** Set raw value and output to blank **/
        (self.outputValue, self.rawValue) = (nil, nil)
    }
}

enum Position {
    case first
    case second
}

enum Operation {
    case plus
    case minus
    case multiply
    case divide
}

enum SecondaryOperation {
    case convertPositiveNegative
    case percent
    case dot
}

