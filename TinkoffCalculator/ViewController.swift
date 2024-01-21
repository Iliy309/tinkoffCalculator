//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by Илья on 21/01/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var labelText: UILabel!
    
    @IBAction func buttonPrassed(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle else{return}
        if labelText.text?.contains(".") == true && buttonText == "."{return}
        
        if labelText.text == "0"{
            labelText.text = buttonText
        } else {
            labelText.text?.append(buttonText)
        }
        
        
        
    }
    
    @IBAction func operationButtonPrassed(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle,
              let buttonOperation = Operation(rawValue: buttonText)
              else {return}
        guard let labeltext = labelText.text,
              let number = numberFormater.number(from: labeltext)?.doubleValue
              else {return}
        
//        labelText.text = buttonText
        
        calculationHistory.append(.numeber(number))
        calculationHistory.append(.operation(buttonOperation))
        
        defaultTextLabel()
    }
    
    @IBAction func buttonResult(_ sender: UIButton) {
        guard let labeltext = labelText.text,
              let number = numberFormater.number(from: labeltext)?.doubleValue
              else {return}
        
        do {
            calculationHistory.append(.numeber(number))
            let result = try calculate()
            labelText.text = numberFormater.string(from: NSNumber(value: result))
        } catch {
            labelText.text = "Error"
        }
    }
    @IBAction func buttonClear(_ sender: UIButton) {
        calculationHistory.removeAll()
        defaultTextLabel()
    }
     
    var calculationHistory:[CalculationItem] = []
    
    enum Operation: String {
        case add = "+"
        case substract = "-"
        case multiply  = "x"
        case devide = "/"
        
        
        func calculate(_ a: Double, _ b: Double) throws -> Double{
            switch self{
            case .add:
                return a + b
            case .substract:
                return a - b
            case .devide:
                if b == 0 { throw CalculationError.devideByZero}
                return a/b
            case .multiply:
                return a*b
            }
        }
        
    }
    
    enum CalculationItem{
        case numeber(Double)
        case operation(Operation)
    }
    
    
    enum CalculationError: Error{
        case devideByZero
        
    }
    
    
    lazy var numberFormater: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.locale = Locale(identifier: "en_US")
        
        return numberFormatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        defaultTextLabel()
    }

    
    
    func calculate() throws  ->  Double {
        guard case CalculationItem.numeber(let firstNumber) = calculationHistory[0] else {return 0}
        
        var currentResult = firstNumber
         
        for index in stride(from: 1, through: calculationHistory.count - 1 , by: 2){
            guard
                case .operation(let operation) = calculationHistory[index],
                case .numeber(let number) = calculationHistory[index + 1]
            else{break}
            
            
            currentResult = try operation.calculate(currentResult, number)
        }
        
        return currentResult
    }

    func defaultTextLabel() {
        labelText.text = "0"
    }
}

