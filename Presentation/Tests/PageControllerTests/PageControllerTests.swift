//
//  PageControllerTests.swift
//  
//
//  Created by 육찬심 on 2021/12/27.
//

import XCTest
import Foundation
import TestExtension
@testable import Views

class PageControllerTests: XCTestCase {
    
    class MockTask {
        
        var callCount = 0
        
        func load(nanoseconds: UInt64) async {
            do {
                try await Task.sleep(nanoseconds: nanoseconds)
                callCount += 1
            } catch {
                NSLog(error.localizedDescription)
            }
        }
    }
    
    func test_pageController_whenExecutesAtTheSameTime_thenExecuteOnlyOne() {
        let mockTask = MockTask() // 3 seconds
        let pageController = PageController<Void>()
        
        // when
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
        
        // then
        XCTAssertTrue(mockTask.callCount == 1, "Called zero or more than 2 - \(mockTask.callCount)")
    }
    
    func test_pageController_whenExecutesAtTheSameTime_thenExecuteTwo() {
        let mockTask = MockTask() // 3 seconds
        let pageController = PageController<Void>()
        
        // when
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
        
        // then
        XCTAssertTrue(mockTask.callCount == 2, "Called zero or more than 2 - \(mockTask.callCount)")
    }
    
    func test_pageController_whenCancel_thenCanceled() {
        let mockTask = MockTask() // 3 seconds
        let pageController = PageController<Void>()
        
        // when
        pageController.load({ _ in
            await mockTask.load(nanoseconds: 1 * 1000 * 1000)
        })
        pageController.cancel()
        
        // than
        XCTAssertTrue(mockTask.callCount == 0, "\(mockTask.callCount)")
        XCTAssertTrue(pageController.currentPage == 1, "\(pageController.currentPage)")
        XCTAssertFalse(pageController.isLoading, "\(pageController.isLoading)")
    }
    
    func test_pageController_whenCancelNext_thenCanceled() {
        let mockTask = MockTask() // 3 seconds
        let pageController = PageController<Void>()
        
        // when
        pageController.load({ _ in
            await mockTask.load(nanoseconds: 1 * 1000 * 1000)
        })
        Thread.sleep(forTimeInterval: 0.2)
        pageController.loadNext(pageInfo: PageInfo(hasMorePage: true, load: { _ in
            await mockTask.load(nanoseconds: 1 * 1000 * 1000)
        }))
        pageController.cancel()
        
        // than
        XCTAssertTrue(mockTask.callCount == 1, "\(mockTask.callCount)")
        XCTAssertTrue(pageController.currentPage == 2, "\(pageController.currentPage)")
        XCTAssertFalse(pageController.isLoading, "\(pageController.isLoading)")
    }
}
