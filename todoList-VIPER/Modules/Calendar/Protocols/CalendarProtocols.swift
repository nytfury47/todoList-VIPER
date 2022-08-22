//
//  CalendarProtocols.swift
//  todoList-VIPER
//
//  Created by gerardo carlos roderico pejo tan on 2022/08/13.
//

import Foundation
import UIKit

/// Delegate for TodoListPresenter to select a calendar date and the associated TodoList.
protocol CalendarModuleDelegate: AnyObject {
    
    /// Calendar date was selected to view the associated TodoList.
    /// - Parameters:
    ///   - scheduledTasks: TodoList for the selected date.
    ///   - newDate: Selected date.
    func didSelectTodoDate(scheduledTasks: TodoScheduled, newDate: Date)
}

/// PRESENTER -> ROUTER
protocol CalendarRouterProtocol {
    
    /// Ask Calendar Router to create Calendar view.
    /// - Parameter delegate: CalendarModuleDelegate (TodoListPresenter).
    /// - Returns: Calendar view controller.
    static func createCalendarModule(with delegate: CalendarModuleDelegate) -> UIViewController
    
    /// Ask Calendar Router to dismiss Calendar view controller (after selecting a date).
    /// - Parameter view: Source view.
    func dismissCalendarView(from view: CalendarViewProtocol)
}

/// PRESENTER -> VIEW
protocol CalendarViewProtocol {
    
    /// Reference to Calendar Presenter instance.
    var presenter: CalendarPresenterProtocol? { get set }
}

/// VIEW -> PRESENTER
protocol CalendarPresenterProtocol {
    
    /// Reference to Calendar Router instance.
    var router: CalendarRouterProtocol? { get set }
    
    /// Reference to Calendar view controller instance.
    var view: CalendarViewProtocol? { get set }
    
    /// Reference to Calendar Interactor instance.
    var interactor: CalendarInteractorInputProtocol? { get set }
    
    /// Reference to CalendarModuleDelegate - TodoListPresenter instance.
    var delegate: CalendarModuleDelegate? { get set }
    
    /// Set the TodoList for the specific date.
    /// - Parameters:
    ///   - scheduledTasks: TodoList for the selected date.
    ///   - newDate: Selected date.
    func didSelectTodoDate(scheduledTasks: TodoScheduled, newDate: Date)
}

/// PRESENTER -> INTERACTOR
protocol CalendarInteractorInputProtocol {
    
    /// Reference to Calendar Presenter instance.
    var presenter: CalendarPresenterProtocol? { get set }
    
    /// Reference to Calendar local data manager instance.
    var localDatamanager: CalendarLocalDataManagerInputProtocol? { get set }
}

/// INTERACTOR -> PRESENTER
protocol CalendarInteractorOutputProtocol { }

/// INTERACTOR -> LOCALDATAMANAGER
protocol CalendarLocalDataManagerInputProtocol { }

/// INTERACTOR -> DATAMANAGER
protocol CalendarDataManagerInputProtocol { }
