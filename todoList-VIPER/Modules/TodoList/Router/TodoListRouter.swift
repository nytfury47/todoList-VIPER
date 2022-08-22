//
//  TodoListRouter.swift
//  todoList-VIPER
//
//  Created by gerardo carlos roderico pejo tan on 2022/07/30.
//

import Foundation
import UIKit

class TodoListRouter: TodoListRouterProtocol {

    static func createTodoListModule() -> UIViewController {
        let mainStoryboard = UIStoryboard(name: Constant.mainStoryboard, bundle: Bundle.main)
        let navController = mainStoryboard.instantiateViewController(withIdentifier: Constant.mainNavController)
        
        if let view = navController.children.first as? TodoListViewController {
            var presenter: TodoListPresenterProtocol & TodoListInteractorOutputProtocol = TodoListPresenter()
            var interactor: TodoListInteractorInputProtocol = TodoListInteractor()
            let localDataManager: TodoListLocalDataManagerInputProtocol = TodoListLocalDataManager()
            let router: TodoListRouterProtocol = TodoListRouter()

            view.presenter = presenter
            presenter.view = view
            presenter.router = router
            presenter.interactor = interactor
            interactor.presenter = presenter
            interactor.localDatamanager = localDataManager

            return navController
        }
        
        return UIViewController()
    }
    
    func presentAddTodoScreen(from view: TodoListViewProtocol, editTask: Todo?, indexPath: IndexPath?, currentDate: Date?) {
        guard let delegate = view.presenter as? AddTodoModuleDelegate else { return }
        
        let addTodoVC = AddTodoRouter.createAddTodoModule(with: delegate)
        
        if let sourceView = view as? UIViewController {
            if let addTaskVC = addTodoVC as? AddTaskViewController {
                addTaskVC.editTask = editTask
                addTaskVC.indexPath = indexPath
                addTaskVC.currentDate = currentDate
            }
            
            sourceView.navigationController?.pushViewController(addTodoVC, animated: true)
        }
    }
    
    func presentCalendarScreen(from view: TodoListViewProtocol, scheduledTodo: TodoScheduled, selectedDate: Date) {
        guard let delegate = view.presenter as? CalendarModuleDelegate else { return }
        
        let calendarVC = CalendarRouter.createCalendarModule(with: delegate)
        
        if let sourceView = view as? UIViewController {
            if let calendarView = calendarVC as? CalendarViewController {
                calendarView.todoScheduled = scheduledTodo
                calendarView.selectedDate = selectedDate
            }
            
            sourceView.navigationController?.pushViewController(calendarVC, animated: true)
        }
    }
}
