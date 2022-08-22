//
//  Todo.swift
//  todoList-VIPER
//
//  Created by gerardo carlos roderico pejo tan on 2022/07/30.
//

import Foundation

/// Entity for basic Todo.
struct Todo: Codable {
    var title: String
    var date: String?
    var time: String?
    var description: String?
    var isCompleted: Bool = false
}

extension Todo: Equatable {
    static let empty = Todo(title: "", date: "", time: "", description: "")
    
    static func == (lhs: Todo, rhs: Todo) -> Bool {
        return (lhs.title == rhs.title &&
                    lhs.date == rhs.date &&
                    lhs.time == rhs.time &&
                    lhs.date == rhs.date &&
                    lhs.description == rhs.description &&
                    lhs.isCompleted == rhs.isCompleted)
    }
}
