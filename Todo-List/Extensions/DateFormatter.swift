//
//  DateFormatter.swift
//  Todo-List
//
//  Created by Yohan Jhaveri on 7/19/21.
//

import Foundation

extension DateFormatter {
    convenience init(format: String) {
        self.init()
        self.dateFormat = format
    }
}
