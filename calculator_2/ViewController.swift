//
//  ViewController.swift
//  calculator_2
//
//  Created by student on 21.03.17.
//  Copyright © 2017 com.sfedu.sinigr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var inputLabel: UILabel!
    let emptyText = ""

    var inputValue: Double = 0
    var precision: Double = 0
    var hasDecimalPoint = false
    var calc : Calculator = Calculator()
    var opType : OperationType? = nil
    var madeOperations: (Bool, Bool) = (false, false)// entered | pressed = | unary
    
    let formatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputLabel.text? = emptyText
        formatter.minimumIntegerDigits = 1
    
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func buttonTouch(_ sender: UIButton) {
        print("12")
        guard let content = sender.titleLabel?.text else {
            print("No text for touched button")
            return
        }
        switch content {
        case "0"..."9":
            if !madeOperations.0
            {
                madeOperations.0 = true
            }
            
            if madeOperations.0 && opType != nil {
                calc.wasActivated = true
            }
            
            if madeOperations.0 && madeOperations.1 {
                calc.wasActivated = false
            }
            
            if hasDecimalPoint {
                precision *= 10
                inputValue += Double(content)! / precision;
            } else {
                inputValue = inputValue * 10 + Double(content)!
            }
            
            printNumber(fracCnt: precision <= 1 ? Int(precision) : min(Int(log(precision)/log(10)), 5),inputValue)
            
        case formatter.decimalSeparator:
            if hasDecimalPoint || !madeOperations.0 {
                return
            }
            hasDecimalPoint = true
            precision = 1
            
            // show point
            print(".")
            
            if inputLabel.text!.isEmpty {
                inputLabel.text = "0" + formatter.decimalSeparator
            } else {
                inputLabel.text = inputLabel.text! + formatter.decimalSeparator
            }
            
        case "-", "+", "*", ":":
            switch content {
            case "-":
                opType = .minus
            case "+":
                opType = .plus
            case "*":
                opType = .mod
            case ":":
                opType = .div
            default:
                return
            }
            
            madeOperations.1 = false
            hasDecimalPoint = false
            
            if !madeOperations.0 {
                return
            }
            
            if !calc.wasActivated {
                calc.result = inputValue
                print("++", calc.result)
            } else {
                makeCalculation(opType!)
            }
            
            inputLabel.text = emptyText
            inputValue = 0
            precision = 0
            
        case "√", "±", "sin", "cos" :
            if (!madeOperations.0 && !madeOperations.1) || opType != nil
            {
                return
            }
            
            if !madeOperations.1 && !calc.wasActivated
            {
                calc.result = inputValue
            }
            
            switch content {
            case "√":
                opType = .sqrt
            case "±":
                opType = .plusMinus
            case "sin":
                opType = .sin
            case "cos":
                opType = .cos
                
            default:
                return
            }
            
            calc.wasActivated = false
            madeOperations.1 = true
            makeCalculation(opType!)
            printCalculatorResult()
            opType = nil
            
            inputValue = 0
            precision = 0
            
        case "=" :
            
            if madeOperations.0 {
                if let op = opType {
                    makeCalculation(op)
                }
            }
            
            printCalculatorResult()
            madeOperations.0 = false
            madeOperations.1 = true
            
            calc.wasActivated = true
            hasDecimalPoint = false
            opType = nil
            inputValue = 0
            precision = 0
            
        default:
            print("Unknown button")
        }
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func makeCalculation(_ op : OperationType) {
        do {
            switch op {
            case .plus:
                try calc += inputValue
            case .minus:
                calc -= inputValue
            case .mod:
                calc *= inputValue
            case .div:
                try calc /= inputValue
            case .sqrt :
                try √calc
            case .plusMinus:
                ±calc
            case .sin:
                sin(calc)
            case .cos:
                cos(calc)
            }
        } catch MyErrors.divideByZero(let errorMessage) {
            let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        catch MyErrors.tooLongNumb(let errorMessage) {
            let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        catch MyErrors.negativeNumber(let errorMessage) {
            let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        catch {
            let alert = UIAlertController(title: "SomeThing Strange", message: ":)", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        inputLabel.text = String(calc.result)
        
        
    }
    
    func printNumber(fracCnt fc: Int, _ d: Double) {
        formatter.minimumFractionDigits = fc
        inputLabel.text = formatter.string(from: NSNumber(value: d))
    }
    
    func printCalculatorResult() {
        let str = String(calc.result)
        let point = str.rangeOfCharacter(from: ["."])?.lowerBound
        printNumber(fracCnt: calc.result.truncatingRemainder(dividingBy: 1.0) < 0.00001 ? 0 : min(str.distance(from: point!, to: str.endIndex) - 1, 5) , calc.result)
    }

}

