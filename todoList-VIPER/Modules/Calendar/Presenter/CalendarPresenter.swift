//
//  CalendarPresenter.swift
//  todoList-VIPER
//
//  Created by gerardo carlos roderico pejo tan on 2022/08/13.
//

import Foundation

class CalendarPresenter: CalendarPresenterProtocol {
    
    var router: CalendarRouterProtocol?
    var view: CalendarViewProtocol?
    var interactor: CalendarInteractorInputProtocol?
    var delegate: CalendarModuleDelegate?
    
    func didSelectTodoDate(scheduledTasks: TodoScheduled, newDate: Date) {
        if let view = view {
            router?.dismissCalendarView(from: view)
            delegate?.didSelectTodoDate(scheduledTasks: scheduledTasks, newDate: newDate)
        }
    }
}

// MARK: - CalendarInteractorOutputProtocol

extension CalendarPresenter: CalendarInteractorOutputProtocol { }
