//
//  CalendarRouter.swift
//  todoList-VIPER
//
//  Created by gerardo carlos roderico pejo tan on 2022/08/13.
//

import Foundation
import UIKit

class CalendarRouter: CalendarRouterProtocol {
    
    static func createCalendarModule(with delegate: CalendarModuleDelegate) -> UIViewController {
        let mainStoryboard = UIStoryboard(name: Constant.mainStoryboard, bundle: Bundle.main)
        let calendarVC = mainStoryboard.instantiateViewController(withIdentifier: CalendarViewController.storyboardID)
        
        if let view = calendarVC as? CalendarViewController {
            var presenter: CalendarPresenterProtocol & CalendarInteractorOutputProtocol = CalendarPresenter()
            var interactor: CalendarInteractorInputProtocol = CalendarInteractor()
            let localDataManager: CalendarLocalDataManagerInputProtocol = CalendarLocalDataManager()
            let router: CalendarRouterProtocol = CalendarRouter()

            view.presenter = presenter
            presenter.view = view
            presenter.router = router
            presenter.interactor = interactor
            presenter.delegate = delegate
            interactor.presenter = presenter
            interactor.localDatamanager = localDataManager

            return calendarVC
        }
        
        return UIViewController()
    }
    
    func dismissCalendarView(from view: CalendarViewProtocol) {
        if let view = view as? UIViewController {
            view.navigationController?.popViewController(animated: true)
        }
    }
}
