//
//  Date+Extensions.swift
//  todoList-VIPER
//
//  Created by gerardo carlos roderico pejo tan on 2022/07/30.
//

import Foundation

extension Date {
    
    /// Convert Date to String.
    /// - Returns: Date in String format.
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = Constant.dateFormat
        return formatter.string(from: self)
    }
    
    /// Convert Time to String.
    /// - Returns: Time in String format.
    func toTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}
