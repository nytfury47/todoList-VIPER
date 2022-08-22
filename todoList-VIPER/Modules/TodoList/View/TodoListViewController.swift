//
//  TodoListViewController.swift
//  todoList-VIPER
//
//  Created by gerardo carlos roderico pejo tan on 2022/07/30.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class TodoListViewController: UIViewController {

    @IBOutlet weak var tblTodo: UITableView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnEditTable: UIBarButtonItem!
    
    private var todoSections: BehaviorRelay<[Task]> = BehaviorRelay(value: [])
    private var dataSource: RxTableViewSectionedReloadDataSource<Task>!
    var viewModel = TodoListViewModel()
    var disposeBag = DisposeBag()
    
    // TodoListViewProtocol
    var presenter: TodoListPresenterProtocol?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Cell registration
        let nibName = UINib(nibName: TodoTableViewCell.nibName, bundle: nil)
        tblTodo.register(nibName, forCellReuseIdentifier: TodoTableViewCell.identifier)
        tblTodo.rowHeight = UITableView.automaticDimension
        
        // UI Binding
        setupBindings()
        
        // SaveDataDelegate
        viewModel.saveDataDelegate = self
        
        presenter?.viewDidLoad()
    }
    
    // MARK: - UI Binding
    
    /// Setup UI Bindings
    func setupBindings() {
        dataSource = RxTableViewSectionedReloadDataSource<Task> { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.identifier, for: indexPath) as! TodoTableViewCell

            // cell setup
            cell.bind(task: item)

            // Add action when checkbox is selected
            cell.btnCheckbox.indexPath = indexPath
            cell.btnCheckbox.addTarget(self, action: #selector(self.checkboxSelection(_:)), for: .touchUpInside)
            return cell
        }
        
        dataSource.titleForHeaderInSection = { ds, index in
            let date = ds.sectionModels[index].date
            return date.isEmpty ? Section.anytime.rawValue : "\(Section.scheduled.rawValue) \(date)"
        }
        
        todoSections.asDriver()
            .drive(tblTodo.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tblTodo.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        tblTodo.rx.itemDeleted
            .bind { indexPath in
                let sectionType: Section = indexPath.section == 0 ? .scheduled : .anytime
                _ = self.viewModel.remove(section: sectionType, row: indexPath.row, date: nil)
            }
            .disposed(by: disposeBag)
        
        tblTodo.rx.itemMoved
            .bind { srcIndexPath, dstIndexPath in
                var movedTask: Todo?
                let sectionType: Section = srcIndexPath.section == 0 ? .scheduled : .anytime
                
                movedTask = self.viewModel.remove(section: sectionType, row: srcIndexPath.row, date: nil)
                
                if let movedTask = movedTask {
                    let sectionType: Section = dstIndexPath.section == 0 ? .scheduled : .anytime
                    self.viewModel.insert(task: movedTask, section: sectionType, row: dstIndexPath.row, date: nil)
                }
            }
            .disposed(by: disposeBag)
        
        Observable.zip(tblTodo.rx.modelSelected(Todo.self), tblTodo.rx.itemSelected)
            .bind { [weak self] (task, indexPath) in
                if let weakSelf = self {
                    weakSelf.presenter?.addNewTodo(from: weakSelf, editTask: task, indexPath: indexPath, currentDate: weakSelf.viewModel.selectedDate.value)
                }
            }
            .disposed(by: disposeBag)
        
        // Update table when TodoList or dates change
        Observable.combineLatest(viewModel.todoScheduled, viewModel.todoAnytime, viewModel.selectedDate)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] scheduled, anytime, date in
                let dateString = date.toString()
                self?.todoSections.accept([Task(date: dateString, items: scheduled[dateString] ?? []),
                                           Task(date: "", items: anytime)])
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Actions
    
    /// Add Todo button is clicked.
    /// - Parameter sender: Add button.
    @IBAction func addTaskButtonPressed(_ sender: UIButton) {
        presenter?.addNewTodo(from: self, editTask: nil, indexPath: nil, currentDate: viewModel.selectedDate.value)
    }
    
    /// Edit Todo button is clicked.
    /// - Parameter sender: Edit button.
    @IBAction func editTableButtonPressed(_ sender: UIBarButtonItem) {
        let buttonTitle = tblTodo.isEditing ? Constant.editButtonTitle : Constant.doneButtonTitle
        let isEditMode = !tblTodo.isEditing
        
        btnEditTable.title = buttonTitle
        tblTodo.setEditing(isEditMode, animated: true)
    }
    
    /// Calendar button is clicked.
    /// - Parameter sender: Calendar button.
    @IBAction func calendarButtonPressed(_ sender: UIBarButtonItem) {
        presenter?.openCalendar(from: self, scheduledTodo: viewModel.todoScheduled.value, selectedDate: viewModel.selectedDate.value)
    }
    
    /// Todo checkbox button is clicked.
    /// - Parameter sender: Checkbox button.
    @objc func checkboxSelection(_ sender: CheckUIButton) {
        guard let indexPath = sender.indexPath else { return }
        
        let sectionType: Section = indexPath.section == 0 ? .scheduled : .anytime
        viewModel.changeComplete(section: sectionType, row: indexPath.row)
    }
}

// MARK: - UITableViewDelegate

extension TodoListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(Constant.todoTableheaderHeight)
    }
}

// MARK: - TodoListViewProtocol

extension TodoListViewController: TodoListViewProtocol {
    
    func reloadInterface(with todoList: (scheduled: TodoScheduled, anytime: TodoAnytime)) {
        viewModel.loadData(scheduledData: todoList.scheduled, anytimeData: todoList.anytime)
        tblTodo.reloadData()
    }
    
    /* AddTask -> TodoList */
    func didAddTodo(oldTask: Todo?, newTask: Todo, indexPath: IndexPath?) {
        let oldDate = oldTask?.date ?? ""
        let newDate = newTask.date ?? ""
        
        // Remove old Todo
        if let _ = oldTask, let index = indexPath {
            if oldDate.isEmpty {    // Anytime
                _ = viewModel.remove(section: .anytime, row: index.row, date: nil)
            } else {                // Scheduled
                _ = viewModel.remove(section: .scheduled, row: index.row, date: oldTask?.date)
            }
        }
        
        // Add new Todo
        if newDate.isEmpty {    // Anytime
            viewModel.insert(task: newTask, section: .anytime, row: indexPath?.row, date: nil)
        } else {                // Scheduled
            viewModel.insert(task: newTask, section: .scheduled, row: indexPath?.row, date: newDate)
        }
    }
    
    /* Calendar -> DailyTasks */
    func didSelectTodoDate(scheduledTasks: TodoScheduled, newDate: Date) {
        if !scheduledTasks.isEmpty {
            viewModel.todoScheduled.accept(scheduledTasks)
        }
        viewModel.selectedDate.accept(newDate)
    }
}

// MARK: - SaveDataDelegate

extension TodoListViewController: SaveDataDelegate {
    
    func saveData<T>(data: T, key: String) where T : Encodable {
        presenter?.saveData(data: data, key: key)
    }
}
