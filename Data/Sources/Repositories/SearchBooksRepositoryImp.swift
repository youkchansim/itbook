//
//  SearchBooksRepositoryImp.swift
//  
//
//  Created by 육찬심 on 2021/12/26.
//

import DTO
import Targets
import Network
import Entities
import Interfaces

public struct SearchBooksRepositoryImp: SearchBooksRepository {
    
    let networkRequestable: NetworkRequestable
    
    public init(
        networkRequestable: NetworkRequestable
    ) {
        self.networkRequestable = networkRequestable
    }
    
    public func fetch(query: String, page: Int) async -> Result<BookPage, Error> {
        let target = SearchBooksTarget(query: query, page: page)
        let result: Result<BookPageDTO, Error> = await networkRequestable.request(target: target)
        return result.map { $0.toBookPage() }
    }
}
