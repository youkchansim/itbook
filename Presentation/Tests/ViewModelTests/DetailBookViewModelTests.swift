//
//  DetailBookViewModelTests.swift
//  
//
//  Created by 육찬심 on 2021/12/28.
//

import Views
import XCTest
import Entities
import UseCases
import Extension

class DetailBookViewModelTests: XCTestCase {
    
    class DetailBookUseCaseMock: DetailBookUseCase {
        
        var callCount = 0
        
        func execute(book: Book) async -> Result<Book, Error> {
            callCount += 1
            return .success(Book(title: "", subtitle: "", price: "", image: "", url: "", isbn13: ""))
        }
    }
    
    class FlowMock: DetailBookFlowDelegate {
        
        var showPurchaseCallCount = 0
        var showPDFCallCount = 0
        
        func showPurchase(_ url: URL) {
            showPurchaseCallCount += 1
        }
        
        func showPDF(_ title: String, url: URL) {
            showPDFCallCount += 1
        }
    }
    
    func test_detailBookViewModel_whenLoad_thenLoadFunctionCallCountIsOne() {
        let mock = DetailBookUseCaseMock()
        let flowMock = FlowMock()
        let sut: DetailBookViewModelType = DetailBookViewModel(book: Book(title: "", subtitle: "", price: "", image: "", url: "", isbn13: ""), detailBookUseCase: mock, flowDelegate: flowMock)
        
        // when
        asyncTest {
            _ = sut.action.load()
        }
        
        // then
        XCTAssertTrue(mock.callCount == 1, "Called zero or more than 2 - count: \(mock.callCount)")
    }
    
    func test_detailBookViewModel_whenPurchase_thenShowWebViewFunctionCallCountIsOne() {
        let mock = DetailBookUseCaseMock()
        let flowMock = FlowMock()
        let sut: DetailBookViewModelType = DetailBookViewModel(book: Book(title: "", subtitle: "", price: "", image: "", url: "https://test.com", isbn13: ""), detailBookUseCase: mock, flowDelegate: flowMock)
        
        // when
        sut.action.purchase()
        
        // then
        XCTAssertTrue(flowMock.showPurchaseCallCount == 1, "Called zero or more than 2 - count: \(flowMock.showPurchaseCallCount)")
    }
    
    func test_detailBookViewModel_whenSelectPDF_thenShowPDFViewFunctionCallCountIsOne() {
        let mock = DetailBookUseCaseMock()
        let flowMock = FlowMock()
        let sut: DetailBookViewModelType = DetailBookViewModel(book: Book(title: "", subtitle: "", price: "", image: "", url: "", isbn13: ""), detailBookUseCase: mock, flowDelegate: flowMock)
        
        // when
        sut.action.select(pdf: ("", "https://test.com"))
        
        // then
        XCTAssertTrue(flowMock.showPDFCallCount == 1, "Called zero or more than 2 - count: \(flowMock.showPDFCallCount)")
    }
}
