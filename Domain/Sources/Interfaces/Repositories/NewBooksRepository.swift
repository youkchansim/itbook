//
//  NewBooksRepository.swift
//  
//
//  Created by 육찬심 on 2021/12/26.
//

import Entities

public protocol NewBooksRepository {
    
    func fetch() async -> Result<[Book], Error>
}
