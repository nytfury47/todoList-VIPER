//
//  String+Extensions.swift
//  todoList-VIPER
//
//  Created by gerardo carlos roderico pejo tan on 2022/07/30.
//

import Foundation

extension String {
    
    /// Convert String to Date.
    /// - Returns: String in Date format.
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = Constant.dateFormat
        return formatter.date(from: self)
    }
    
    /// Convert String to Time.
    /// - Returns: String in Time format.
    func toTime() -> Date? {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.date(from: self)
    }
}
