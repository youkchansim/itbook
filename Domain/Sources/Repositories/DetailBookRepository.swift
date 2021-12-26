//
//  DetailBookRepository.swift
//  
//
//  Created by 육찬심 on 2021/12/26.
//

import Entities

public protocol DetailBookRepository {
    
    func fetch(book: Book) async -> Result<Book, Error>
}
