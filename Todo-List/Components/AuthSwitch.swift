//
//  AuthSwitch.swift
//  Todo-List
//
//  Created by Yohan Jhaveri on 7/9/21.
//

import UIKit

class AuthSwitch: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 5
        self.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        self.setTitleColor(.white, for: .application)
    }
}
