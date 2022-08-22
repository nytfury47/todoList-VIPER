//
//  CalendarViewController.swift
//  todoList-VIPER
//
//  Created by gerardo carlos roderico pejo tan on 2022/08/13.
//

import UIKit
import FSCalendar
import RxSwift
import RxCocoa

class CalendarViewController: UIViewController, CalendarViewProtocol {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tblTasks: UITableView!
    @IBOutlet weak var btnScope: UIBarButtonItem!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Instance Properties
    
    static let storyboardID = Constant.calendarStoryboardID
    
    var todoScheduled: TodoScheduled = [:]
    var selectedDate = Date()
    
    // CalendarViewProtocol
    var presenter: CalendarPresenterProtocol?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Cell registration
        let nibName = UINib(nibName: TodoTableViewCell.nibName, bundle: nil)
        tblTasks.register(nibName, forCellReuseIdentifier: TodoTableViewCell.identifier)
        tblTasks.rowHeight = UITableView.automaticDimension
        
        // Show previously selected date
        calendar.select(selectedDate)
        
        // Set calendar height to half of full view
        calendarHeightConstraint.constant = self.view.bounds.height / 2
        // Change title color for a weekend
        calendar.calendarWeekdayView.weekdayLabels[0].textColor = UIColor(red: 255/255, green: 126/255, blue: 121/255, alpha: 1.0)
        calendar.calendarWeekdayView.weekdayLabels[6].textColor = calendar.calendarWeekdayView.weekdayLabels[0].textColor
    }
    
    // MARK: - Actions
    
    /// Checkbox button is clicked.
    /// - Parameter sender: Checkbox button.
    @objc func checkboxSelection(_ sender: CheckUIButton) {
        guard let indexPath = sender.indexPath else { return }
        
        // Update isCompleted
        todoScheduled[selectedDate.toString()]?[indexPath.row].isCompleted.toggle()
        
        tblTasks.reloadData()
        calendar.reloadData()
    }
    
    /// Done button is clicked.
    /// - Parameter sender: Done button.
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        // Return to TodoList view
        presenter?.didSelectTodoDate(scheduledTasks: todoScheduled, newDate: selectedDate)
    }
    
    /// Change scope between Week/Month
    /// - Parameter sender: Change scope button.
    @IBAction func changeScopeButtonPressed(_ sender: UIBarButtonItem) {
        let scope: FSCalendarScope = calendar.scope == .month ? .week : .month
        let scopeButtonTitle = calendar.scope == .month ? Constant.calendarScopeButtonTitleMonth : Constant.calendarScopeButtonTitleWeek
        
        calendar.scope = scope
        btnScope.title = scopeButtonTitle
    }
}

// MARK: - UITableViewDataSource

extension CalendarViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoScheduled[selectedDate.toString()]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return selectedDate.toString()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.identifier, for: indexPath) as! TodoTableViewCell
        guard let task = todoScheduled[selectedDate.toString()]?[indexPath.row] else { return cell }
        
        // Setup cell
        cell.bind(task: task)
        
        // Add action when checkbox is selected
        cell.btnCheckbox.indexPath = indexPath
        cell.btnCheckbox.addTarget(self, action: #selector(checkboxSelection(_:)), for: .touchUpInside)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CalendarViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(Constant.todoTableheaderHeight)
    }
}
    
// MARK: - Calendar Delegate

extension CalendarViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    /* Select date */
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        tblTasks.reloadData()
    }
    
    /* Change the calendar height when changing the scope between Week/Month */
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    /* Show events on calendar dates */
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if let tasks = todoScheduled[date.toString()], tasks.count > 0 { return 1 }
        return 0
    }
    
    /* Event color */
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        return getCalendarEventColor(for: date)    }
    
    /* Event color when selecting a date */
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        return getCalendarEventColor(for: date)
    }
}

// MARK: - Utility

extension CalendarViewController {
    
    /// Utility function for Calendar Delegate - getting the event color
    /// - Parameter date: Specified date.
    /// - Returns: Appropriate UIColor for calendar event.
    func getCalendarEventColor(for date: Date) -> [UIColor]? {
        if let tasks = todoScheduled[date.toString()] {
            // Display event in Red when Todo is incomplete
            if tasks.filter({ $0.isCompleted == false }).count > 0 { return [UIColor.systemRed] }
            // Display event in Gray when Todo is completed
            return [UIColor.systemGray2]
        }
        return nil
    }
}
