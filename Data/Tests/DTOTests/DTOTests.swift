//
//  DTOTests.swift
//  
//
//  Created by 육찬심 on 2021/12/26.
//

import DTO
import XCTest

class DTOTests: XCTestCase {
    
    func test_bookDTO_WhenJsonDecode_thenToBook() {
        guard let jsonData =
        """
            {
                "title": "Designing Across Senses",
                "subtitle": "",
                "isbn13": "9781491954249",
                "price": "$27.59",
                "image": "https://itbook.store/img/books/9781491954249.png",
                "url": "https://itbook.store/books/9781491954249"
            }
        """.data(using: .utf8) else {
            XCTFail("Unsupport json string")
            return
        }
        
        do {
            let result = try JSONDecoder().decode(BookDTO.self, from: jsonData)
            let book = result.toBook()
            XCTAssertTrue(book.title == "Designing Across Senses")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_bookPageDTO_WhenJsonDecode_thenToBookPage() {
        guard let jsonData =
        """
            {
                "error":"0",
                "total":"20",
                "books":
                    [
                        {
                            "title":"Architect Modern Web Applications with ASP.NET Core and Azure",
                            "subtitle":"",
                            "isbn13":"1001635859865",
                            "price":"$0.00",
                            "image":"https://itbook.store/img/books/1001635859865.png",
                            "url":"https://itbook.store/books/1001635859865"
                        },
                        {
                            "title":"Graph-Powered Machine Learning",
                            "subtitle":"",
                            "isbn13":"9781617295645",
                            "price":"$49.99",
                            "image":"https://itbook.store/img/books/9781617295645.png",
                            "url":"https://itbook.store/books/9781617295645"
                        }
                    ]
        
            }
        """.data(using: .utf8) else {
            XCTFail("Unsupport json string")
            return
        }
        
        do {
            let result = try JSONDecoder().decode(BookPageDTO.self, from: jsonData)
            let bookPage = result.toBookPage()
            XCTAssertTrue(bookPage.total == "20")
            XCTAssertTrue(!bookPage.books.isEmpty)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
