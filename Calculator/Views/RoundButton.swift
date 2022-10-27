//
//  RoundButton.swift
//  Calculator
//
//  Created by Pavel on 26.10.22.
//

import UIKit

class RoundButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 24
    }
}
