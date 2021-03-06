//
//  String.swift
//  Todo-List
//
//  Created by Yohan Jhaveri on 7/20/21.
//

import Foundation

extension String {
    var isEmailFormat: Bool {
        return NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
}
