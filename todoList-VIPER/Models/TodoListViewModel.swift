//
//  TodoListViewModel.swift
//  todoList-VIPER
//
//  Created by gerardo carlos roderico pejo tan on 2022/07/30.
//

import Foundation
import RxSwift
import RxCocoa

/// View model for TodoListViewController > TodoList table view.
class TodoListViewModel: NSObject {
    var todoScheduled = BehaviorRelay<TodoScheduled>(value: [:])    // e.g. "2020-09-23" : [Todo]
    var todoAnytime = BehaviorRelay<TodoAnytime>(value: [])
    var selectedDate = BehaviorRelay<Date>(value: Date())
    
    // SaveDataDelegate
    weak var saveDataDelegate: SaveDataDelegate?
    
    var disposeBag = DisposeBag()
    
    override init() {
        super.init()
        
        // Save when date is updated
        _ = todoScheduled
            .skip(1)
            .subscribe(onNext: { [weak self] in
                self?.saveDataDelegate?.saveData(data: $0, key: Section.scheduled.rawValue)
            })
            .disposed(by: disposeBag)
        
        _ = todoAnytime
            .skip(1)
            .subscribe(onNext: { [weak self] in
                self?.saveDataDelegate?.saveData(data: $0, key: Section.anytime.rawValue)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Data Processing
    
    /// Load first data from source.
    /// - Parameters:
    ///   - scheduledData: Todo list with date.
    ///   - anytimeData: Todo list without date.
    func loadData(scheduledData: TodoScheduled, anytimeData: TodoAnytime) {
        todoScheduled.accept(scheduledData)
        todoAnytime.accept(anytimeData)
    }
    
    // MARK: - Tasks
    
    /// Update Todo checkbox for completed status.
    /// - Parameters:
    ///   - section: Todo type.
    ///   - row: Todo row number.
    func changeComplete(section: Section, row: Int) {
        if section == .scheduled {
            var tasks = todoScheduled.value
            let date = selectedDate.value.toString()
            tasks[date]?[row].isCompleted.toggle()
            todoScheduled.accept(tasks)
        } else if section == .anytime {
            var tasks = todoAnytime.value
            tasks[row].isCompleted.toggle()
            todoAnytime.accept(tasks)
        }
    }
    
    /// Add new Todo.
    /// - Parameters:
    ///   - task: Todo info.
    ///   - section: Todo type.
    ///   - row: Todo row number.
    ///   - date: Todo target date.
    func insert(task: Todo, section: Section, row: Int?, date: String?) {
        var task = task
        
        if section == .scheduled {
            var scheduled = todoScheduled.value
            let date = date ?? selectedDate.value.toString()
            var newTasks = todoScheduled.value[date] ?? []
            
            task.date = date
            if let row = row { newTasks.insert(task, at: row) }
            else { newTasks.append(task) }
            
            scheduled[date] = newTasks
            todoScheduled.accept(scheduled)
        } else if section == .anytime {
            var anytime = todoAnytime.value
            
            task.date = ""
            task.time = ""
            if let row = row { anytime.insert(task, at: row) }
            else { anytime.append(task) }
            
            todoAnytime.accept(anytime)
        }
    }
    
    /// Delete Todo.
    /// - Parameters:
    ///   - section: Todo type.
    ///   - row: Todo row number.
    ///   - date: Todo target date.
    /// - Returns: Todo object to delete.
    func remove(section: Section, row: Int, date: String?) -> Todo? {
        var removedTask: Todo?
        
        if section == .scheduled {
            var scheduled = todoScheduled.value
            let date = date ?? selectedDate.value.toString()
            
            removedTask = scheduled[date]?.remove(at: row)
            todoScheduled.accept(scheduled)
        } else if section == .anytime {
            var anytime = todoAnytime.value
            
            removedTask = anytime.remove(at: row)
            todoAnytime.accept(anytime)
        }
        
        return removedTask
    }
}
