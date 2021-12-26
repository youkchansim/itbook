//
//  File.swift
//  
//
//  Created by 육찬심 on 2021/12/26.
//

import Entities
import Repositories

public protocol DetailBookUseCase {
        
    func execute(book: Book) async -> Result<Book, Error>
}

public struct DetailBookUseCaseImp: DetailBookUseCase {
    
    private let repository: DetailBookRepository
    
    public init(
        repository: DetailBookRepository
    ) {
        self.repository = repository
    }
    
    public func execute(book: Book) async -> Result<Book, Error> {
        return await repository.fetch(book: book)
    }
}
