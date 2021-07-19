//
//  TextInput.swift
//  Todo-List
//
//  Created by Yohan Jhaveri on 7/6/21.
//

import UIKit


class CustomTextField: UITextField {
    func addLeftPadding() {
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 20))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func addCornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func addBorder(width: CGFloat, color: CGColor) {
        self.layer.borderColor = color
        self.layer.borderWidth = width
    }
    
    func addPlaceholder(text: String, color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor : color])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addLeftPadding()
        addCornerRadius(radius: 5)
        addPlaceholder(text: self.placeholder!, color: UIColor.lightText)
    }

}
