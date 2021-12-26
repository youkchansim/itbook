//
//  SearchBooksRepository.swift
//  
//
//  Created by 육찬심 on 2021/12/26.
//

import Entities

public protocol SearchBooksRepository {
    
    func fetch(query: String, page: Int) async -> Result<BookPage, Error>
}
