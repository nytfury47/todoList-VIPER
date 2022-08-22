//
//  TodoListPresenter.swift
//  todoList-VIPER
//
//  Created by gerardo carlos roderico pejo tan on 2022/08/05.
//

import Foundation

class TodoListPresenter: TodoListPresenterProtocol {
    
    var router: TodoListRouterProtocol?
    var view: TodoListViewProtocol?
    var interactor: TodoListInteractorInputProtocol?
    
    func viewDidLoad() {
        interactor?.retrieveTodoList()
    }

    func addNewTodo(from view: TodoListViewProtocol, editTask: Todo?, indexPath: IndexPath?, currentDate: Date?) {
        router?.presentAddTodoScreen(from: view, editTask: editTask, indexPath: indexPath, currentDate: currentDate)
    }
    
    func openCalendar(from view: TodoListViewProtocol, scheduledTodo: TodoScheduled, selectedDate: Date) {
        router?.presentCalendarScreen(from: view, scheduledTodo: scheduledTodo, selectedDate: selectedDate)
    }
    
    func saveData<T>(data: T, key: String) where T : Encodable {
        interactor?.saveData(data: data, key: key)
    }
}

// MARK: - TodoListInteractorOutputProtocol

extension TodoListPresenter: TodoListInteractorOutputProtocol {
    
    func didRetrieveTodoList(_ todoList: (scheduled: TodoScheduled, anytime: TodoAnytime)) {
        view?.reloadInterface(with: todoList)
    }
    
}

// MARK: - AddTodoModuleDelegate

extension TodoListPresenter: AddTodoModuleDelegate {
    
    func didAddTodo(oldTask: Todo?, newTask: Todo, indexPath: IndexPath?) {
        view?.didAddTodo(oldTask: oldTask, newTask: newTask, indexPath: indexPath)
    }
}

// MARK: - CalendarModuleDelegate

extension TodoListPresenter: CalendarModuleDelegate {
    
    func didSelectTodoDate(scheduledTasks: TodoScheduled, newDate: Date) {
        view?.didSelectTodoDate(scheduledTasks: scheduledTasks, newDate: newDate)
    }
}
