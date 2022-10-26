//
//  ResultLabel.swift
//  Calculator
//
//  Created by Pavel on 26.10.22.
//

import UIKit

class Resultlabel: UILabel {

    init() {
        super.init(frame: .zero)
        textColor = .white
        text = "0"
        adjustsFontSizeToFitWidth = true
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont(name: "WorkSans-Regular", size: 50)
        textAlignment = .right
        numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
