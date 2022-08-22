//
//  TodoListInteractor.swift
//  todoList-VIPER
//
//  Created by gerardo carlos roderico pejo tan on 2022/08/05.
//

import Foundation

class TodoListInteractor: TodoListInteractorInputProtocol {
    
    var presenter: TodoListInteractorOutputProtocol?
    var localDatamanager: TodoListLocalDataManagerInputProtocol?
    
    func retrieveTodoList() {
        if let todoList = localDatamanager?.retrieveTodoList() {
            presenter?.didRetrieveTodoList(todoList)
        } else {
            presenter?.didRetrieveTodoList(([:], []))
        }
    }
    
    func saveData<T>(data: T, key: String) where T : Encodable {
        localDatamanager?.saveData(data: data, key: key)
    }
}
