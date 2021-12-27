//
//  MemoryCacheTests.swift
//  
//
//  Created by 육찬심 on 2021/12/27.
//

import XCTest
import Cache

class MemoryCacheTests: XCTestCase {
    
    func test_memoryCacheTests_whenCaching_thenCached() {
        let cacher = MemoryCacher(capacity: 1)
        
        // when
        if let image = UIImage(systemName: "book") {
            cacher.add(key: "TEST", value: image)
        }
        
        // then
        XCTAssertTrue(cacher.get(key: "TEST") != nil, "Failed caching")
    }
    
    func test_memoryCacheTests_whenRemoveingObject_thenRemoved() {
        let cacher = MemoryCacher(capacity: 1)
        if let image = UIImage(systemName: "book") {
            cacher.add(key: "TEST1", value: image)
        }
        
        // when
        cacher.remove(key: "TEST1")
        
        // then
        XCTAssertTrue(cacher.get(key: "TEST1") == nil, "Failed Removing")
    }
    
    func test_memoryCacheTests_whenRemoveingAllObject_thenAllRemoved() {
        let cacher = MemoryCacher(capacity: 1)
        let keys = (0...30).map { "TEST\($0)" }
        keys.forEach {
            if let image = UIImage(systemName: "book") {
                cacher.add(key: $0, value: image)
            }
        }
        
        // when
        cacher.removeAll()
        
        // then
        let cachedObject = keys.compactMap { cacher.get(key: $0) }
        XCTAssertTrue(cachedObject.isEmpty, "Failed Removing All - \(cachedObject.count)")
    }
}
