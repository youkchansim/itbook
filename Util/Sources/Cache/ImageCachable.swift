//
//  ImageCachable.swift
//  
//
//  Created by 육찬심 on 2021/12/27.
//

import Foundation
import UIKit

public protocol ImageCachable {
    
    func add(key: String, value: UIImage)
    func get(key: String) -> UIImage?
    func remove(key: String)
    func removeAll()
}
