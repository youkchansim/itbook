//
//  DetailBookRepositoryImpTests.swift
//  
//
//  Created by 육찬심 on 2021/12/26.
//

import XCTest
import Entities
import Extension
import Repositories

class DetailBookRepositoryImpTests: XCTestCase {
    
    func test_detailBookRepositoryImp_whenRequest_thenCallCountIsOne() {
        let mock = NetworkRequestableMock()
        let repository = DetailBookRepositoryImp(networkRequestable: mock)
        let book = Book(title: "", subtitle: "", price: "", image: "", url: "", isbn13: "")
        
        // when
        asyncTest {
            _ = await repository.fetch(book: book)
        }
        
        // then
        XCTAssertTrue(mock.requestCallCount == 1, "'fetch' was called zero or more than 2 - count: \(mock.requestCallCount)")
    }
}
