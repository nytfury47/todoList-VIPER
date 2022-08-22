//
//  AddTodoInteractor.swift
//  todoList-VIPER
//
//  Created by gerardo carlos roderico pejo tan on 2022/08/12.
//

import Foundation

class AddTodoInteractor: AddTodoInteractorInputProtocol {
    
    var presenter: AddTodoPresenterProtocol?
    var localDatamanager: AddTodoLocalDataManagerInputProtocol?
}
