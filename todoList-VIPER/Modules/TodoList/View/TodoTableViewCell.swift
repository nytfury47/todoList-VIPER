//
//  TodoTableViewCell.swift
//  todoList-VIPER
//
//  Created by gerardo carlos roderico pejo tan on 2022/08/11.
//

import UIKit
import RxSwift
import RxCocoa

class TodoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnCheckbox: CheckUIButton!
    
    static let nibName = Constant.todoCellNibName
    static let identifier = Constant.todoCellIdentifier
    
    var viewModel = TodoViewModel(Todo.empty)
    var disposeBag = DisposeBag()
    
    // MARK: - View Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    // MARK: - UI Binding
    
    /// Create TodoViewModel and bind to TodoTableViewCell
    /// - Parameter task: Todo data.
    func bind(task: Todo) {
        viewModel = TodoViewModel(task)
        
        // UI Binding
        setupBindings()
    }
    
    /// Setup UI Bindings
    func setupBindings() {
        let task = viewModel.task.asDriver()
        
        // Title
        task.map { $0.title }
            .drive(lblTitle.rx.text)
            .disposed(by: disposeBag)
        
        // Description
        task.map { $0.description ?? "" }
            .drive(lblDescription.rx.text)
            .disposed(by: disposeBag)
        
        task.map {
                if $0.description?.isEmpty == false { return false }
                return true
            }
            .drive(lblDescription.rx.isHidden)
            .disposed(by: disposeBag)
        
        // Time
        task.map { $0.time ?? "" }
            .drive(lblTime.rx.text)
            .disposed(by: disposeBag)
        
        task.map {
                if $0.time?.isEmpty == false { return false }
                return true
            }
            .drive(lblTime.rx.isHidden)
            .disposed(by: disposeBag)
        
        // Checkbox button
        viewModel.checkImageString.asDriver(onErrorJustReturn: Constant.checkBoxImageName)
            .map { UIImage(systemName: $0) }
            .drive(btnCheckbox.rx.backgroundImage())
            .disposed(by: disposeBag)
    }
}

/// Custom UIButton with indexPath
class CheckUIButton : UIButton {
    
    var indexPath: IndexPath?
}
