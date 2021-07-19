//
//  AuthLabel.swift
//  Todo-List
//
//  Created by Yohan Jhaveri on 7/9/21.
//

import UIKit

class AuthLabel: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.textColor = .white
        self.font = UIFont.systemFont(ofSize: 18)
    }
}
