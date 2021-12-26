//
//  SearchBooksUseCase.swift
//  
//
//  Created by 육찬심 on 2021/12/26.
//

import Entities
import Interfaces

public protocol SearchBooksUseCase {
    
    func execute(query: String, page: Int) async -> Result<BookPage, Error>
}

public struct SearchBooksUseCaseImp: SearchBooksUseCase {
    
    private let repository: SearchBooksRepository
    
    public init(
        repository: SearchBooksRepository
    ) {
        self.repository = repository
    }
    
    public func execute(query: String, page: Int) async -> Result<BookPage, Error> {
        return await repository.fetch(query: query, page: page)
    }
}
