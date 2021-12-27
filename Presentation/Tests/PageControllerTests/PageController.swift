//
//  PageController.swift
//  
//
//  Created by 육찬심 on 2021/12/27.
//

import XCTest
import Extension
import Foundation
@testable import Views

class PageControllerTests: XCTestCase {
    
    class MockTask {
        
        var callCount = 0
        
        func load(nanoseconds: UInt64) async {
            try? await Task.sleep(nanoseconds: nanoseconds)
            callCount += 1
        }
    }
    
    func test_pageController_whenExecutesAtTheSameTime_thenExecuteOnlyOne() {
        let mockTask = MockTask() // 3 seconds
        let pageController = PageController<Void>()
        
        pageController.loadNext(pageInfo: PageInfo(hasMorePage: true, load: { _ in
            await mockTask.load(nanoseconds: 1 * 1000 * 1000 * 1000)
        }))
        pageController.loadNext(pageInfo: PageInfo(hasMorePage: true, load: { _ in
            await mockTask.load(nanoseconds: 1 * 1000 * 1000)
        }))
        pageController.loadNext(pageInfo: PageInfo(hasMorePage: true, load: { _ in
            await mockTask.load(nanoseconds: 1 * 1000)
        }))
        
        Thread.sleep(forTimeInterval: 1.1)
        
        XCTAssertTrue(mockTask.callCount == 1, "Called zero or more than 2 - \(mockTask.callCount)")
    }
    
    func test_pageController_whenExecutesAtTheSameTime_thenExecuteTwo() {
        let mockTask = MockTask() // 3 seconds
        let pageController = PageController<Void>()
        
        pageController.loadNext(pageInfo: PageInfo(hasMorePage: true, load: { _ in
            await mockTask.load(nanoseconds: 1 * 1000 * 1000)
        }))
        pageController.loadNext(pageInfo: PageInfo(hasMorePage: true, load: { _ in
            await mockTask.load(nanoseconds: 1 * 1000 * 1000)
        }))
        Thread.sleep(forTimeInterval: 0.1)
        pageController.loadNext(pageInfo: PageInfo(hasMorePage: true, load: { _ in
            await mockTask.load(nanoseconds: 1 * 1000 * 1000)
        }))
        
        Thread.sleep(forTimeInterval: 0.2)
        
        XCTAssertTrue(mockTask.callCount == 2, "Called zero or more than 2 - \(mockTask.callCount)")
    }
}
