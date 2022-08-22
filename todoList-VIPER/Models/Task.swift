//
//  Task.swift
//  todoList-VIPER
//
//  Created by gerardo carlos roderico pejo tan on 2022/07/30.
//

import Foundation
import RxDataSources

/// Entity for Todo list per date.
struct Task {
    var date: String
    var items: [Todo]
}

extension Task: SectionModelType {
    typealias Item = Todo
    
    init(original: Task, items: [Item]) {
        self = original
        self.items = items
    }
}
