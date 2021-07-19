//
//  AuthButton.swift
//  Todo-List
//
//  Created by Yohan Jhaveri on 7/9/21.
//

import UIKit

class AuthButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 5
        self.backgroundColor = .white
        self.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        self.setTitleColor(CustomColors.darkGreen, for: .application)
    }
}
