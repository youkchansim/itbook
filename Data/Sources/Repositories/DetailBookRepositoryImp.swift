//
//  DetailBookRepositoryImp.swift
//  
//
//  Created by 육찬심 on 2021/12/26.
//

import DTO
import Targets
import Network
import Entities
import Interfaces

public struct DetailBookRepositoryImp: DetailBookRepository {
    
    let networkRequestable: NetworkRequestable
    
    public init(
        networkRequestable: NetworkRequestable
    ) {
        self.networkRequestable = networkRequestable
    }
    
    public func fetch(book: Book) async -> Result<Book, Error> {
        let target = DetailBookTarget(isbn13: book.isbn13)
        let result: Result<BookDTO, Error> = await networkRequestable.request(target: target)
        return result.map { $0.toBook() }
    }
}
