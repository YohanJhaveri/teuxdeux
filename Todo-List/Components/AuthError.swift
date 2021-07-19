//
//  AuthError.swift
//  Todo-List
//
//  Created by Yohan Jhaveri on 7/9/21.
//

import UIKit

class AuthError: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.textColor = CustomColors.inputError
        self.font = UIFont.systemFont(ofSize: 17)
    }
}
