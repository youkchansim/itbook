//
//  SearchBooksTarget.swift
//  
//
//  Created by 육찬심 on 2021/12/26.
//

import Network
import Alamofire

public struct SearchBooksTarget: RequestTarget {
    
    public let query: String
    public let page: Int
    
    public init(
        query: String,
        page: Int
    ) {
        self.query = query
        self.page = page
    }
    
    public var path: String { "search/\(query)/\(page)" }
}
