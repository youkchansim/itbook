//
//  XCTest+Extension.swift
//
//
//  Created by 육찬심 on 2021/12/26.
//

import XCTest

public extension XCTestCase {
    
    func asyncTest(timeout: TimeInterval = 1, asyncBlock: @escaping () async -> Void) {
        let expectation = expectation(description: #function)
        Task {
            await asyncBlock()
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout)
    }
}
