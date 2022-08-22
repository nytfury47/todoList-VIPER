//
//  UIViewController+Extensions.swift
//  todoList-VIPER
//
//  Created by gerardo carlos roderico pejo tan on 2022/07/30.
//

import Foundation
import UIKit

extension UIViewController {
    
    /// Instantiate view controller using the specified storyboard and identifier.
    /// - Parameters:
    ///   - storyboard: Source storyboard.
    ///   - identifier: View controller identifier.
    /// - Returns: The view controller corresponding to the specified storyboard and identifier string.
    class func instantiate<T: UIViewController>(from storyboard: UIStoryboard, identifier: String) -> T {
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
    
    /// Instantiate view controller using the specified storyboard and view controller class name as identifier.
    /// - Parameter storyboard: Source storyboard.
    /// - Returns: The view controller corresponding to the specified storyboard.
    class func instantiate(from storyboard: UIStoryboard) -> Self {
        return instantiate(from: storyboard, identifier: String(describing: self))
    }
    
    /// Instantiate view controller using self as identifier for storyboard and class name.
    /// - Returns: The view controller corresponding to the specified identifier.
    class func instantiate() -> Self {
        let className = String(describing: self)
        return instantiate(from: UIStoryboard(name: className, bundle: Bundle(for: self)),
                           identifier: className)
    }
}
