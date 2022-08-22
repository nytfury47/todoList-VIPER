//
//  TodoListProtocols.swift
//  todoList-VIPER
//
//  Created by gerardo carlos roderico pejo tan on 2022/07/30.
//

import Foundation
import UIKit

/// Delegate for TodoListViewModel to save TodoList data.
protocol SaveDataDelegate: AnyObject {
    
    /// Save TodoList data to data manager.
    /// - Parameters:
    ///   - data: Data to save.
    ///   - key: Key associated with data to save.
    func saveData<T>(data: T, key: String) where T : Encodable
}

/// PRESENTER -> ROUTER
protocol TodoListRouterProtocol {
    
    /// Ask TodoList Router to create TodoList view.
    /// - Returns: TodoList view controller.
    static func createTodoListModule() -> UIViewController

    /// Ask TodoList Router to present the Add Todo view.
    /// - Parameters:
    ///   - view: Source view.
    ///   - editTask: Selected todo (if for edit/update).
    ///   - indexPath: Index from list.
    ///   - currentDate: Current selected date.
    func presentAddTodoScreen(from view: TodoListViewProtocol, editTask: Todo?, indexPath: IndexPath?, currentDate: Date?)
    
    /// Ask TodoList Router to present the Calendar view.
    /// - Parameters:
    ///   - view: Source view.
    ///   - scheduledTodo: Scheduled todo data.
    ///   - selectedDate: Target calendar to present.
    func presentCalendarScreen(from view: TodoListViewProtocol, scheduledTodo: TodoScheduled, selectedDate: Date)
}

/// PRESENTER -> VIEW
protocol TodoListViewProtocol {
    
    /// Reference to TodoList Presenter instance.
    var presenter: TodoListPresenterProtocol? { get set }
    
    /// Inform TodoList view controller of the retrieved Todo list data.
    /// - Parameter todoList: Todo list data retrieved from data manager.
    func reloadInterface(with todoList: (scheduled: TodoScheduled, anytime: TodoAnytime))
    
    /// AddTodoModuleDelegate callback. Inform TodoList view controller that a Todo is added (or updated).
    /// - Parameters:
    ///   - oldTask: Original todo data.
    ///   - newTask: New (or updated) todo data.
    ///   - indexPath: Index from list.
    func didAddTodo(oldTask: Todo?, newTask: Todo, indexPath: IndexPath?)
    
    /// CalendarModuleDelegate callback. Inform TodoList view controller that a specific date has been selected.
    /// - Parameters:
    ///   - scheduledTasks: Todo list for the selected date.
    ///   - newDate: Selected date.
    func didSelectTodoDate(scheduledTasks: TodoScheduled, newDate: Date)
}

/// VIEW -> PRESENTER
protocol TodoListPresenterProtocol {
    
    /// Reference to TodoList Router instance.
    var router: TodoListRouterProtocol? { get set }
    
    /// Reference to TodoList view controller instance.
    var view: TodoListViewProtocol? { get set }
    
    /// Reference to TodoList Interactor instance.
    var interactor: TodoListInteractorInputProtocol? { get set }

    /// viewDidLoad event from TodoList view controller.
    func viewDidLoad()
    
    /// Ask Presenter to present Add Todo view.
    /// - Parameters:
    ///   - view: Source view.
    ///   - editTask: Currently selected todo (if for edit).
    ///   - indexPath: Index from list.
    ///   - currentDate: Current selected date.
    func addNewTodo(from view: TodoListViewProtocol, editTask: Todo?, indexPath: IndexPath?, currentDate: Date?)
    
    /// Ask Presenter to present Calendar view.
    /// - Parameters:
    ///   - view: Source view.
    ///   - scheduledTodo: Scheduled todo list data.
    ///   - selectedDate: Current selected date.
    func openCalendar(from view: TodoListViewProtocol, scheduledTodo: TodoScheduled, selectedDate: Date)
    
    /// Ask Presenter to save todo list data to data manager.
    /// - Parameters:
    ///   - data: Data to save.
    ///   - key: Key associated with data to save.
    func saveData<T: Encodable>(data: T, key: String)
}

/// PRESENTER -> INTERACTOR
protocol TodoListInteractorInputProtocol {
    
    /// Reference to TodoList Presenter instance.
    var presenter: TodoListInteractorOutputProtocol? { get set }
    
    /// Reference to TodoList local data manager instance.
    var localDatamanager: TodoListLocalDataManagerInputProtocol? { get set }

    /// Ask Interactor to retrieve todo list data from local data manager.
    func retrieveTodoList()
    
    /// Ask Interactor to save todo list data to local data manager.
    /// - Parameters:
    ///   - data: Data to save.
    ///   - key: Key associated with data to save.
    func saveData<T: Encodable>(data: T, key: String)
}

/// INTERACTOR -> PRESENTER
protocol TodoListInteractorOutputProtocol {
    
    /// Pass retrieved todo list data from Interactor to Presenter.
    /// - Parameter todoList: Tuple of scheduled and non-scheduled todo list data.
    func didRetrieveTodoList(_ todoList: (scheduled: TodoScheduled, anytime: TodoAnytime))
}

/// INTERACTOR -> LOCALDATAMANAGER
protocol TodoListLocalDataManagerInputProtocol {
    
    /// Retrieve saved todo list data from local data manager.
    /// - Returns: Tuple of scheduled and non-scheduled todo list data.
    func retrieveTodoList() -> (scheduled: TodoScheduled, anytime: TodoAnytime)
    
    /// Save data to local data manager.
    /// - Parameters:
    ///   - data: Data to save.
    ///   - key: Key associated with data to save.
    func saveData<T: Encodable>(data: T, key: String)
}

/// INTERACTOR -> DATAMANAGER
protocol TodoListDataManagerInputProtocol { }
