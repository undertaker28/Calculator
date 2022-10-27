//
//  LogicOperations.swift
//  Calculator
//
//  Created by Pavel on 27.10.22.
//

import Foundation

class LogicOperations {
    
    private lazy var accumulator = 0.0
    private lazy var previousAccumulator = 0.0
    private lazy var previousPriority = 20
    private lazy var pending: [PendingBinaryOperationInfo] = []
    private var previousOperation: PendingBinaryOperationInfo?
    var result: Double {
        return accumulator
    }
    
    private enum Operation {
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double, Int)
        case percentOperation((Double) -> Double, (Double, Double) -> Double)
        case equals
        case clear
    }
    
    // MARK: - Saving information on the deferred operation into the structure: first operator and function
    private struct PendingBinaryOperationInfo {
        var function: ((Double, Double) -> Double)
        var firstOperand: Double
    }
    
    private var operations: [String: Operation] = [
        "⁺∕₋": Operation.unaryOperation{ -$0 },
        "×": Operation.binaryOperation({ $0 * $1 }, 1),
        "+": Operation.binaryOperation({ $0 + $1 }, 0),
        "-": Operation.binaryOperation({ $0 - $1 }, 0),
        "÷": Operation.binaryOperation({ $0 / $1 }, 1),
        "=": Operation.equals,
        "%": Operation.percentOperation({ $0 / 100 }, { $0 * $1 / 100 }),
        "C": Operation.clear
    ]
    
    // MARK: - Setting initial value
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    // MARK: - Perform incoming operation or delay
    func performOperation(symbol: String, getBothOperandsForBinaryOperation: Bool = true) {
        if let operation = operations[symbol] {
            switch operation {
            case .unaryOperation(let function):
                accumulator = function(accumulator)
                previousAccumulator = accumulator
            case .binaryOperation(let function, let priority):
                if getBothOperandsForBinaryOperation {
                    if pending.count > 0 {
                        if previousPriority > priority {
                            executePendingOperations()
                        } else if previousPriority == priority {
                            executeLastPendingOperation()
                        }
                    }
                    pending.append(PendingBinaryOperationInfo(function: function, firstOperand: accumulator))
                    previousPriority = priority
                    previousAccumulator = accumulator
                }
            case .percentOperation(let oneDigitPercent, let twoDigitPercent):
                if pending.count > 0 {
                    print("test")
                    accumulator = twoDigitPercent(accumulator, previousAccumulator)
                } else {
                    accumulator = oneDigitPercent(accumulator)
                }
                previousAccumulator = accumulator
            case .equals:
                if pending.count > 0 {
                    if let function = pending.last?.function {
                        previousOperation = PendingBinaryOperationInfo(function: function, firstOperand: accumulator)
                    }
                    executePendingOperations()
                }
                else if let operation = previousOperation {
                    accumulator = operation.function(accumulator, operation.firstOperand)
                }
                previousAccumulator = accumulator
            case .clear:
                clear()
            }
        }
    }
    
    func clear() {
        accumulator = 0.0
        previousAccumulator = 0.0
        pending = []
        previousOperation = nil
    }
    
    // MARK: - Performing all deferred operations from the array
    private func executePendingOperations() {
        while pending.count > 0 {
            executeLastPendingOperation()
        }
    }
    
    // MARK: - Performing the last deferred operation
    private func executeLastPendingOperation() {
        let operation = pending.removeLast()
        accumulator = operation.function(operation.firstOperand, accumulator)
    }
}
