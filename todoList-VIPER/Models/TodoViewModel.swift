//
//  TodoViewModel.swift
//  todoList-VIPER
//
//  Created by gerardo carlos roderico pejo tan on 2022/07/30.
//

import Foundation
import RxSwift
import RxCocoa

/// View model for TodoTableViewCell.
class TodoViewModel: NSObject {
    var task = BehaviorRelay<Todo>(value: Todo.empty)
    var disposeBag = DisposeBag()
    
    init(_ task: Todo) {
        _ = BehaviorSubject<Todo>.just(task)
            .take(1)
            .subscribe(onNext: self.task.accept(_:))
            .disposed(by: disposeBag)
    }
    
    lazy var checkImageString: Observable<String> = self.task.map { return $0.isCompleted ? Constant.checkBoxImageNameFilled : Constant.checkBoxImageName }
}
