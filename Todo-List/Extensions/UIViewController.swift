//
//  UIViewController.swift
//  Todo-List
//
//  Created by Yohan Jhaveri on 7/20/21.
//

import Foundation
import UIKit

extension UIViewController {
    func enableKeyboardDimissOnOutsidePress() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
