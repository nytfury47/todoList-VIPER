//
//  AddTodoProtocols.swift
//  todoList-VIPER
//
//  Created by gerardo carlos roderico pejo tan on 2022/08/12.
//

import Foundation
import UIKit

/// Delegate for TodoListPresenter to add new or update Todo.
protocol AddTodoModuleDelegate: AnyObject {
    
    /// Todo was added or updated.
    /// - Parameters:
    ///   - oldTask: Original todo data.
    ///   - newTask: New (or updated) todo data.
    ///   - indexPath: Index from list.
    func didAddTodo(oldTask: Todo?, newTask: Todo, indexPath: IndexPath?)
}

/// PRESENTER -> ROUTER
protocol AddTodoRouterProtocol {
    
    /// Ask AddTodo Router to create AddTodo view.
    /// - Parameter delegate: AddTodoModuleDelegate (TodoListPresenter).
    /// - Returns: AddTodo view controller.
    static func createAddTodoModule(with delegate: AddTodoModuleDelegate) -> UIViewController
    
    /// Ask AddTodo Router to dismiss AddTodo view controller (after adding/updating a Todo).
    /// - Parameter view: Source view.
    func dismissAddTodoView(from view: AddTodoViewProtocol)
}

/// PRESENTER -> VIEW
protocol AddTodoViewProtocol {
    
    /// Reference to AddTodo Presenter instance.
    var presenter: AddTodoPresenterProtocol? { get set }
}

/// VIEW -> PRESENTER
protocol AddTodoPresenterProtocol {
    
    /// Reference to AddTodo Router instance.
    var router: AddTodoRouterProtocol? { get set }
    
    /// Reference to AddTodo view controller instance.
    var view: AddTodoViewProtocol? { get set }
    
    /// Reference to AddTodo Interactor instance.
    var interactor: AddTodoInteractorInputProtocol? { get set }
    
    /// Reference to AddTodoModuleDelegate - TodoListPresenter instance.
    var delegate: AddTodoModuleDelegate? { get set }

    /// Add new or update Todo.
    /// - Parameters:
    ///   - oldTask: Original todo data.
    ///   - newTask: New (or updated) todo data.
    ///   - indexPath: Index from list.
    func addNewTodo(oldTask: Todo?, newTask: Todo, indexPath: IndexPath?)
}

/// PRESENTER -> INTERACTOR
protocol AddTodoInteractorInputProtocol {
    
    /// Reference to AddTodo Presenter instance.
    var presenter: AddTodoPresenterProtocol? { get set }
    
    /// Reference to AddTodo local data manager instance.
    var localDatamanager: AddTodoLocalDataManagerInputProtocol? { get set }
}

/// INTERACTOR -> PRESENTER
protocol AddTodoInteractorOutputProtocol { }

/// INTERACTOR -> LOCALDATAMANAGER
protocol AddTodoLocalDataManagerInputProtocol { }

/// INTERACTOR -> DATAMANAGER
protocol AddTodoDataManagerInputProtocol { }
