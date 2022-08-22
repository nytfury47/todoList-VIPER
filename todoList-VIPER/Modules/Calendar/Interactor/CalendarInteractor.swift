//
//  CalendarInteractor.swift
//  todoList-VIPER
//
//  Created by gerardo carlos roderico pejo tan on 2022/08/13.
//

import Foundation

class CalendarInteractor: CalendarInteractorInputProtocol {
    
    var presenter: CalendarPresenterProtocol?
    var localDatamanager: CalendarLocalDataManagerInputProtocol?
}
