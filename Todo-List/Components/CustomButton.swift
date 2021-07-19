//
//  CustomButton.swift
//  Todo-List
//
//  Created by Yohan Jhaveri on 7/7/21.
//

import UIKit

class CustomButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 5
    }
}
