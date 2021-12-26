//
//  NewBooksTarget.swift
//  
//
//  Created by 육찬심 on 2021/12/26.
//

import Network
import Alamofire

public struct NewBooksTarget: RequestTarget {
    
    public init() {}
    
    public var path: String { "new" }
}
