//
//  Utility.swift
//  todoList-VIPER
//
//  Created by gerardo carlos roderico pejo tan on 2022/08/11.
//

import Foundation

// MARK: - typealias

typealias TodoScheduled = [String : [Todo]]
typealias TodoAnytime = [Todo]

// MARK: - Enums/Constants

/// Todo types.
enum Section: String {
    
    case scheduled = "Scheduled"
    case anytime = "Anytime"
}

/// Local storage (UserDefaults) keys
enum DefaultsKey {
    
    static let isFirstLaunch = "isFirstLaunch"
}

/// Constants
enum Constant {
    
    static let dateFormat = "yyyy-MM-dd"
    
    static let mainStoryboard = "Main"
    static let mainNavController = "TodoListNavigationController"
    
    static let checkBoxImageName = "circle"
    static let checkBoxImageNameFilled = "checkmark.circle.fill"
    
    static let todoTableheaderHeight = 35
    
    // TodoList
    static let editButtonTitle = "Edit"
    static let doneButtonTitle = "Done"
    
    static let todoCellNibName = "TodoTableViewCell"
    static let todoCellIdentifier = "TodoCell"
    
    static let todoDefaultTitle = "Create new task"
    static let todoDefaultTitle2 = "Update your task"
    static let todoDefaultTime = "8:00 PM"
    static let todoDefaultDescription = "Click the plus button to add a scheduled task."
    static let todoDefaultDescription2 = "This task has not yet been scheduled."
    
    // AddTodo
    static let addTodoStoryboardID = "addTask"
    static let addTodoViewCreateTitle = "Create Task"
    static let addTodoViewEditTitle = "Edit Task"
    
    // Calendar
    static let calendarStoryboardID = "calendarTask"
    static let calendarScopeButtonTitleMonth = "Month"
    static let calendarScopeButtonTitleWeek = "Week"
}
