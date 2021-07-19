//
//  AuthField.swift
//  Todo-List
//
//  Created by Yohan Jhaveri on 7/9/21.
//

import UIKit

class AuthField: UITextField {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.textColor = .white
        self.font = UIFont.systemFont(ofSize: 18)
        self.minimumFontSize = 18
        self.backgroundColor = CustomColors.lightGreen
        self.tintColor = CustomColors.darkGreen
        self.attributedPlaceholder = NSAttributedString(
            string: self.placeholder!,
            attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightText]
        )
    }
}
