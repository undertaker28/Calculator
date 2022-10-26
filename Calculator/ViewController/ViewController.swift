//
//  ViewController.swift
//  Calculator
//
//  Created by Pavel on 26.10.22.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private lazy var digitsAndSymbols = [
        "C", "⁺∕₋", "%", "÷", "7", "8", "9", "×", "4", "5", "6", "-", "1", "2", "3", "+", "0", ",", "=",
    ]
    private lazy var colorsArray: [UIColor] = [#colorLiteral(red: 0.3040827513, green: 0.3140518367, blue: 0.3736236691, alpha: 1), #colorLiteral(red: 0.295702666, green: 0.3668284416, blue: 0.988561213, alpha: 1), #colorLiteral(red: 0.1794961393, green: 0.1844775975, blue: 0.2185646594, alpha: 1)]
    private lazy var stackOfStacks = UIStackView()
    private lazy var stackArray = [UIStackView]()
    private lazy var buttons = [RoundButton]()
    private lazy var resultLabel = Resultlabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.09019548446, green: 0.09019654244, blue: 0.1115591601, alpha: 1)
        stackOfStacks.backgroundColor = view.backgroundColor
        stackOfStacks.axis = .vertical
        stackOfStacks.alignment = .fill
        stackOfStacks.distribution = .fillEqually
        stackOfStacks.spacing = 16
        formingStack()
        view.addSubview(resultLabel)
        view.addSubview(stackOfStacks)
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
            button.titleLabel?.font = UIFont(name: "WorkSans-Regular", size: 36)
            switch digitsAndSymbols[element] {
            case "C", "%", "⁺∕₋":
                button.backgroundColor = colorsArray[0]
                button.setTitle(digitsAndSymbols[element], for: .normal)
            case "÷", "×", "-", "+", "=":
                button.backgroundColor = colorsArray[1]
                button.setTitle(digitsAndSymbols[element], for: .normal)
            default:
                button.backgroundColor = colorsArray[2]
                button.setTitle(digitsAndSymbols[element], for: .normal)
            }
            if button.titleLabel?.text == "0" {
                button.contentEdgeInsets.right = 90
                button.snp.makeConstraints {
                    $0.width.equalTo(button.snp.height).multipliedBy(2)
                }
            } else {
                button.snp.makeConstraints {
                    $0.width.equalTo(button.snp.height).multipliedBy(1)
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
    
}

