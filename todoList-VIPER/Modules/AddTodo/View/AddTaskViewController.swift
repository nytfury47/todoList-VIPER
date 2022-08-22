//
//  AddTaskViewController.swift
//  todoList-VIPER
//
//  Created by gerardo carlos roderico pejo tan on 2022/08/12.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa

class AddTaskViewController: UIViewController, AddTodoViewProtocol {
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var btnSave: UIBarButtonItem!
    @IBOutlet weak var viewTaskDetails: UIStackView!
    @IBOutlet weak var segctrlTime: UISegmentedControl!
    
    // MARK: - Instance Properties
    
    static let storyboardID = Constant.addTodoStoryboardID
    
    let scheduled = 0, anytime = 1
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    
    var editTask: Todo?
    var indexPath: IndexPath?
    var currentDate: Date?
    
    // AddTodoViewProtocol
    var presenter: AddTodoPresenterProtocol?
    
    var disposeBag = DisposeBag()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI Binding
        setupBindings()
        
        // Create DatePicker
        addDatePicker()
        addTimePicker()
        
        // Title Focus
        txtTitle.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let task = editTask else {
            self.title = Constant.addTodoViewCreateTitle
            datePicker.date = currentDate ?? Date()
            datePicker.sendActions(for: .valueChanged)
            btnSave.isEnabled = false
            return
        }
        
        // Depends if Create or Edit mode
        self.title = Constant.addTodoViewEditTitle
        btnSave.isEnabled = true
        
        // Scheduled / Anytime
        if let date = task.date, !date.isEmpty {
            segctrlTime.selectedSegmentIndex = scheduled
        } else {
            segctrlTime.selectedSegmentIndex = anytime
        }
        segctrlTime.sendActions(for: .valueChanged)
        
        // Fill data
        txtTitle.text = task.title
        txtDescription.text = task.description
        
        if let date = task.date, let pickerDate = date.toDate() {
            datePicker.date = pickerDate
            datePicker.sendActions(for: .valueChanged)
        }
        
        if let time = task.time, let pickerTime = time.toTime() {
            timePicker.date = pickerTime
            timePicker.sendActions(for: .valueChanged)
        } else {
            txtTime.text = ""
        }
    }
    
    // MARK: - UI Binding
    
    /// Setup UI bindings.
    func setupBindings() {
        txtTitle.rx.text.asDriver()
            .map {
                guard let title = $0, !title.isEmpty else { return false }
                return true
            }
            .drive(btnSave.rx.isEnabled)
            .disposed(by: disposeBag)
        
        segctrlTime.rx.selectedSegmentIndex.asDriver()
            .map { return ($0 == self.scheduled ? false : true) }
            .drive(onNext: { [weak self] in
                self?.viewTaskDetails.subviews[0].isHidden = $0
                self?.viewTaskDetails.subviews[1].isHidden = $0
            })
            .disposed(by: disposeBag)
        
        datePicker.rx.date.asDriver()
            .map { $0.toString() }
            .drive(txtDate.rx.text)
            .disposed(by: disposeBag)
        
        timePicker.rx.date.asDriver()
            .map { $0.toTimeString() }
            .drive(txtTime.rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK: - DatePicker
    
    /// Add Date Picker.
    func addDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let btnSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let btnDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        toolbar.setItems([btnSpace, btnDone], animated: true)
        
        txtDate.inputView = datePicker
        txtDate.inputAccessoryView = toolbar
        
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
    }
    
    /// Add Time Picker.
    func addTimePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let btnTrash = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashPressed))
        let btnSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let btnDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        toolbar.setItems([btnTrash, btnSpace, btnDone], animated: true)
        
        txtTime.inputView = timePicker
        txtTime.inputAccessoryView = toolbar
        
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.datePickerMode = .time
    }
    
    // MARK: - Actions
    
    /// Save button is clicked to add or update Todo.
    /// - Parameter sender: Save button.
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        txtTitle.endEditing(true)
        txtDescription.endEditing(true)
        
        var date: String? = ""
        var time: String? = ""
        
        if segctrlTime.selectedSegmentIndex == scheduled {
            date = txtDate.text
            time = txtTime.text
        }
        let todoObject = Todo(title: txtTitle.text!, date: date, time: time, description: txtDescription.text)
        
        // Return to TodoList view
        presenter?.addNewTodo(oldTask: editTask, newTask: todoObject, indexPath: indexPath)
    }
    
    /// Done button is clicked to complete Date/Time selection.
    @objc func donePressed() {
        self.view.endEditing(true)
    }
    
    /// Trash button for removing Todo due time is clicked.
    @objc func trashPressed() {
        txtTime.text = ""
        self.view.endEditing(true)
    }
}
