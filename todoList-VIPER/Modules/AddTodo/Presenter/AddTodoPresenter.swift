//
//  AddTodoPresenter.swift
//  todoList-VIPER
//
//  Created by gerardo carlos roderico pejo tan on 2022/08/12.
//

import Foundation

class AddTodoPresenter: AddTodoPresenterProtocol {
    
    var router: AddTodoRouterProtocol?
    var view: AddTodoViewProtocol?
    var interactor: AddTodoInteractorInputProtocol?
    var delegate: AddTodoModuleDelegate?
    
    func addNewTodo(oldTask: Todo?, newTask: Todo, indexPath: IndexPath?) {
        if let view = view {
            router?.dismissAddTodoView(from: view)
            delegate?.didAddTodo(oldTask: oldTask, newTask: newTask, indexPath: indexPath)
        }
    }
}

// MARK: - AddTodoInteractorOutputProtocol

extension AddTodoPresenter: AddTodoInteractorOutputProtocol { }
