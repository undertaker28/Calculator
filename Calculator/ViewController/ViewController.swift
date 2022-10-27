//
//  ViewController.swift
//  Calculator
//
//  Created by Pavel on 26.10.22.
//

import UIKit
import SnapKit
import Switches

class ViewController: UIViewController {
    
    private lazy var digitsAndSymbols = ["C", "⁺∕₋", "%", "÷", "7", "8", "9", "×", "4", "5", "6", "-", "1", "2", "3", "+", "0", ",", "="]
    private lazy var colorsArray: [UIColor?] = [UIColor(named: "Operators"), UIColor(named: "SimpleOperators"), UIColor(named: "Numbers")]
    private lazy var stackOfStacks = UIStackView()
    private lazy var stackArray = [UIStackView]()
    private lazy var buttons = [RoundButton]()
    private lazy var resultLabel = Resultlabel()
    private lazy var typing = false
    private lazy var logic = LogicOperations()
    private lazy var index = 1
    private lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 9
        formatter.groupingSeparator = " "
        formatter.locale = Locale.current
        return formatter
    }()
    
    private lazy var switchButton: YapModeSwitch! = {
        let switchBtn = YapModeSwitch()
        if MTUserDefaults.shared.theme.rawValue == 1 {
            switchBtn.isOn = false
        } else {
            switchBtn.isOn = true
        }
        switchBtn.thumbRadiusPadding = 8
        switchBtn.thumbTintColor = #colorLiteral(red: 0.295702666, green: 0.3668284416, blue: 0.988561213, alpha: 1)
        switchBtn.offTintColor = .white
        switchBtn.onTintColor = #colorLiteral(red: 0.1794961393, green: 0.1844775975, blue: 0.2185646594, alpha: 1)
        switchBtn.addTarget(self, action: #selector(switchButtonToggle(_:)), for: .valueChanged)
        return switchBtn
    }()
    
    var displayValue: Double? {
        get {
            if let text = resultLabel.text, let value = Double(text.replacingOccurrences(of: ",", with: ".")) {
                return value
            } else {
                return nil
            }
        }
        set {
            if let value = newValue {
                resultLabel.text = formatter.string(from: NSNumber(value: value))
            } else {
                resultLabel.text = "0"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        stackOfStacks.backgroundColor = view.backgroundColor
        stackOfStacks.axis = .vertical
        stackOfStacks.alignment = .fill
        stackOfStacks.distribution = .fillEqually
        stackOfStacks.spacing = 16
        formingStack()
        view.addSubview(resultLabel)
        view.addSubview(stackOfStacks)
        view.addSubview(switchButton)
        makeConstraints()
    }
    
    func makeConstraints() {
        stackOfStacks.snp.makeConstraints { stack in
            stack.bottom.equalToSuperview().offset(-50)
            stack.leading.equalToSuperview().offset(20)
            stack.trailing.equalToSuperview().offset(-20)
            stack.height.equalTo(stackOfStacks.snp.width).multipliedBy(1.25)
        }
        resultLabel.snp.makeConstraints { label in
            label.bottom.equalTo(stackOfStacks.snp.top).offset(-8)
            label.leading.equalToSuperview().offset(26)
            label.trailing.equalToSuperview().offset(-26)
            label.height.equalTo(70)
        }
        switchButton.snp.makeConstraints { toogle in
            toogle.top.equalToSuperview().offset(90)
            toogle.leading.equalToSuperview().offset(155)
            toogle.trailing.equalToSuperview().offset(-155)
            toogle.height.equalTo(40)
        }
    }
    
    func formingStack() {
        addButtonsToArray()
        addButtonsToStack()
        for stack in stackArray {
            stackOfStacks.addArrangedSubview(stack)
        }
    }
    
    func addButtonsToArray() {
        for element in 0..<digitsAndSymbols.count {
            let button = RoundButton()
            button.titleLabel?.font = UIFont(name: "WorkSans-Regular", size: 40)
            switch digitsAndSymbols[element] {
            case "C", "%", "⁺∕₋":
                button.backgroundColor = colorsArray[0]
                button.setTitle(digitsAndSymbols[element], for: .normal)
                button.setTitleColor(UIColor(named: "TextColor"), for: .normal)
                button.layer.borderWidth = 1
                button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                if digitsAndSymbols[element] == "C" {
                    button.addTarget(self, action: #selector(self.pressC(_:)), for: .touchUpInside)
                } else {
                    button.addTarget(self, action: #selector(self.pressOperator(_:)), for: .touchUpInside)
                }
            case "÷", "×", "-", "+", "=":
                button.backgroundColor = colorsArray[1]
                button.setTitle(digitsAndSymbols[element], for: .normal)
                button.setTitleColor(UIColor.white, for: .normal)
                button.addTarget(self, action: #selector(self.pressOperator(_:)), for: .touchUpInside)
            default:
                button.layer.borderWidth = 1
                button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                button.backgroundColor = colorsArray[2]
                button.setTitle(digitsAndSymbols[element], for: .normal)
                button.setTitleColor(UIColor(named: "TextColor"), for: .normal)
                button.addTarget(self, action: #selector(self.pressNumber(_:)), for: .touchUpInside)
            }
            if button.titleLabel?.text == "0" {
                button.contentEdgeInsets.right = 90
                button.snp.makeConstraints { buttonZero in
                    buttonZero.width.equalTo(button.snp.height).multipliedBy(2)
                }
            } else {
                button.snp.makeConstraints { normalButton in
                    normalButton.width.equalTo(button.snp.height).multipliedBy(1)
                }
            }
            buttons.append(button)
        }
    }
    
    func addButtonsToStack() {
        for _ in 1...5 {
            stackArray.append(UIStackView())
        }
        stackArray.forEach { stack in
            stack.axis = .horizontal
            stack.alignment = .fill
            stack.distribution = .fillEqually
            stack.spacing = 16
        }
        stackArray[4].distribution = .fill
        
        for index in 0..<buttons.count {
            switch index {
            case 0...3: stackArray[0].addArrangedSubview(buttons[index])
            case 4...7: stackArray[1].addArrangedSubview(buttons[index])
            case 8...11: stackArray[2].addArrangedSubview(buttons[index])
            case 12...15: stackArray[3].addArrangedSubview(buttons[index])
            default: stackArray[4].addArrangedSubview(buttons[index])
            }
        }
    }
    
    @objc func switchButtonToggle(_ sender: YapDarkAndLightModeSwitch) {
        index = 1
        if switchButton.isOn {
            index = 2
        }
        MTUserDefaults.shared.theme = Theme(rawValue: index) ?? .unspecified
        view.window?.overrideUserInterfaceStyle = MTUserDefaults.shared.theme.getUserInterfaceStyle()
    }
    
    @objc func pressNumber(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text, let displayedText = resultLabel.text else { return }
        if typing {
            if buttonTitle != "," || (buttonTitle == "," && displayedText.contains(",") == false) {
                if displayedText != "0" {
                    resultLabel.text = displayedText + buttonTitle
                } else {
                    resultLabel.text = (buttonTitle == "," ? "0," : buttonTitle)
                }
            }
        } else {
            resultLabel.text = (buttonTitle == "," ? "0," : buttonTitle)
        }
        typing = true
    }
    
    @objc func pressOperator(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        
        // MARK: - For negative numbers
        if buttonTitle == "-" {
            typing = true
        }
        let needCalculation = typing
        if typing, let value = displayValue {
            logic.setOperand(operand: value)
            typing = false
        }
        logic.performOperation(symbol: buttonTitle, getBothOperandsForBinaryOperation: needCalculation)
        displayValue = logic.result
    }
    
    @objc func pressC(_ sender: UIButton) {
        if sender.currentTitle == "C" {
            logic.clear()
            displayValue = 0
            typing = false
        }
    }
    
}
