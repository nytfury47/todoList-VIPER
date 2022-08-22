//
//  AddTodoRouter.swift
//  todoList-VIPER
//
//  Created by gerardo carlos roderico pejo tan on 2022/08/12.
//

import Foundation
import UIKit

class AddTodoRouter: AddTodoRouterProtocol {
    
    static func createAddTodoModule(with delegate: AddTodoModuleDelegate) -> UIViewController {
        let mainStoryboard = UIStoryboard(name: Constant.mainStoryboard, bundle: Bundle.main)
        let addTodoVC = mainStoryboard.instantiateViewController(withIdentifier: AddTaskViewController.storyboardID)
        
        if let view = addTodoVC as? AddTaskViewController {
            var presenter: AddTodoPresenterProtocol & AddTodoInteractorOutputProtocol = AddTodoPresenter()
            var interactor: AddTodoInteractorInputProtocol = AddTodoInteractor()
            let localDataManager: AddTodoLocalDataManagerInputProtocol = AddTodoLocalDataManager()
            let router: AddTodoRouterProtocol = AddTodoRouter()

            view.presenter = presenter
            presenter.view = view
            presenter.router = router
            presenter.interactor = interactor
            presenter.delegate = delegate
            interactor.presenter = presenter
            interactor.localDatamanager = localDataManager

            return addTodoVC
        }
        
        return UIViewController()
    }
    
    func dismissAddTodoView(from view: AddTodoViewProtocol) {
        if let view = view as? UIViewController {
            view.navigationController?.popViewController(animated: true)
        }
    }
}
