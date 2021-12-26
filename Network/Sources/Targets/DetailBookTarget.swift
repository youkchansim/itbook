//
//  DetailBookTarget.swift
//  
//
//  Created by 육찬심 on 2021/12/26.
//

import Network
import Alamofire

public struct DetailBookTarget: RequestTarget {
    
    public let isbn13: String
    
    public init(
        isbn13: String
    ) {
        self.isbn13 = isbn13
    }
    
    public var path: String { "books/\(isbn13)" }
}
