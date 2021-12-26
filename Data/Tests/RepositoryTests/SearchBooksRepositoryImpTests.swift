//
//  SearchBooksRepositoryImpTests.swift
//  
//
//  Created by 육찬심 on 2021/12/26.
//

import XCTest
import Entities
import Extension
import Repositories

class SearchBooksRepositoryImpTestsTests: XCTestCase {
    
    func test_searchBooksRepositoryImpImp_whenRequest_thenCallCountIsOne() {
        let mock = NetworkRequestableMock()
        let repository = SearchBooksRepositoryImp(networkRequestable: mock)
        
        // when
        asyncTest {
            _ = await repository.fetch(query: "", page: 0)
        }
        
        // then
        XCTAssertTrue(mock.requestCallCount == 1, "'fetch' was called zero or more than 2 - count: \(mock.requestCallCount)")
    }
}
