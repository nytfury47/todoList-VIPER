//
//  TodoListLocalDataManager.swift
//  todoList-VIPER
//
//  Created by gerardo carlos roderico pejo tan on 2022/08/05.
//

import Foundation

class TodoListLocalDataManager: TodoListLocalDataManagerInputProtocol {
    
    func retrieveTodoList() -> (scheduled: TodoScheduled, anytime: TodoAnytime) {
        var scheduledData: TodoScheduled = [:]
        var anytimeData: TodoAnytime = []
        
        // Load first data
        if nil != UserDefaults.standard.value(forKey: DefaultsKey.isFirstLaunch) {
            loadAllData(scheduledData: &scheduledData, anytimeData: &anytimeData)   // Import previous data
        } else {
            loadFirstData(scheduledData: &scheduledData, anytimeData: &anytimeData) // Import first data
        }
        
        return (scheduled: scheduledData, anytime: anytimeData)
    }
    
    func saveData<T>(data: T, key: String) where T : Encodable {
        let userDefaults = UserDefaults.standard
        let encoder = JSONEncoder()
        
        if let jsonData = try? encoder.encode(data) {
            if let jsonString = String(data: jsonData, encoding: .utf8){
                userDefaults.set(jsonString, forKey: key)
            }
        }
        
        // Synchronization
        userDefaults.synchronize()
    }
}

private extension TodoListLocalDataManager {
    
    /// Load previous data.
    /// - Parameters:
    ///   - scheduledData: TodoList data with dates.
    ///   - anytimeData: TodoList data without dates.
    func loadAllData(scheduledData: inout TodoScheduled, anytimeData: inout TodoAnytime) {
        let userDefaults = UserDefaults.standard
        let decoder = JSONDecoder()
        
        // Scheduled
        if let jsonString = userDefaults.value(forKey: Section.scheduled.rawValue) as? String {
            if let jsonData = jsonString.data(using: .utf8),
               let data = try? decoder.decode(TodoScheduled.self, from: jsonData) {
                scheduledData = data
            }
        }
        
        // Anytime
        if let jsonString = userDefaults.value(forKey: Section.anytime.rawValue) as? String {
            if let jsonData = jsonString.data(using: .utf8),
               let data = try? decoder.decode(TodoAnytime.self, from: jsonData) {
                anytimeData = data
            }
        }
    }
    
    /// Load initial data.
    /// - Parameters:
    ///   - scheduledData: TodoList data with dates.
    ///   - anytimeData: TodoList data without dates.
    func loadFirstData(scheduledData: inout TodoScheduled, anytimeData: inout TodoAnytime) {
        let userDefaults = UserDefaults.standard
        let date = Date().toString()
        
        userDefaults.setValue(false, forKey: DefaultsKey.isFirstLaunch)
        scheduledData = [date : [Todo(title: Constant.todoDefaultTitle,
                                      date: date,
                                      time: Constant.todoDefaultTime,
                                      description: Constant.todoDefaultDescription)]]
        anytimeData = [Todo(title: Constant.todoDefaultTitle2, date: "", time: "", description: Constant.todoDefaultDescription2)]
        userDefaults.synchronize()
    }
}
