//
//  NewBooksRepositoryImp.swift
//  
//
//  Created by 육찬심 on 2021/12/26.
//

import DTO
import Targets
import Network
import Entities
import Interfaces

public struct NewBooksRepositoryImp: NewBooksRepository {
    
    let networkRequestable: NetworkRequestable
    
    public init(
        networkRequestable: NetworkRequestable
    ) {
        self.networkRequestable = networkRequestable
    }
    
    public func fetch() async -> Result<[Book], Error> {
        let target = NewBooksTarget()
        let result: Result<[BookDTO], Error> = await networkRequestable.request(target: target)
        return result.map { dtos in dtos.map { $0.toBook() } }
    }
}
