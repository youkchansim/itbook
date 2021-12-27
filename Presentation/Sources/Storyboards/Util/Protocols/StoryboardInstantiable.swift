//
//  File.swift
//  
//
//  Created by 육찬심 on 2021/12/26.
//

import UIKit
import Foundation

public protocol StoryboardInstantiable {
    
    static var storyboardName: String { get }
    static var identifier: String { get }
}

public extension StoryboardInstantiable where Self: UIViewController {
    
    static var identifier: String { String(describing: self) }
    
    static func create() -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: .module)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? Self else {
            fatalError("ViewController's identifier is invalid")
        }
        
        return viewController
    }
}
