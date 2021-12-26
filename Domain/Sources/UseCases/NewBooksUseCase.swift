//
//  NewBooksUseCase.swift
//  
//
//  Created by 육찬심 on 2021/12/26.
//

import Entities
import Interfaces

public protocol NewBooksUseCase {
    
    func execute() async -> Result<[Book],Error>
}

public struct NewBooksUseCaseImp: NewBooksUseCase {
    
    private let repository: NewBooksRepository
    
    public init(
        repository: NewBooksRepository
    ) {
        self.repository = repository
    }
    
    public func execute() async -> Result<[Book],Error> {
        return await repository.fetch()
    }
}
