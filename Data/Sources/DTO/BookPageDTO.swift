//
//  File.swift
//  
//
//  Created by 육찬심 on 2021/12/26.
//

import Entities

public struct BookPageDTO: Decodable {
    
    public let error: String
    public let total: String
    public let page: String?
    public let books: [BookDTO]
}

public extension BookPageDTO {
    
    func toBookPage() -> BookPage {
        return BookPage(total: total,
                     page: page ?? "",
                     books: books.map { $0.toBook() })
    }
}
