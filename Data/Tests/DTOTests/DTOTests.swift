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
                "subtitle": "A Multimodal Approach to Product Design",
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
                "total": "48",
                "page": "1",
                "books": [
                    {
                        "title": "Practical MongoDB",
                        "subtitle": "Architecting, Developing, and Administering MongoDB",
                        "isbn13": "9781484206485",
                        "price": "$32.04",
                        "image": "https://itbook.store/img/books/9781484206485.png",
                        "url": "https://itbook.store/books/9781484206485"
                    },
                    {
                        "title": "The Definitive Guide to MongoDB, 3rd Edition",
                        "subtitle": "A complete guide to dealing with Big Data using MongoDB",
                        "isbn13": "9781484211830",
                        "price": "$47.11",
                        "image": "https://itbook.store/img/books/9781484211830.png",
                        "url": "https://itbook.store/books/9781484211830"
                    },
                    {
                        "title": "MongoDB in Action, 2nd Edition",
                        "subtitle": "Covers MongoDB version 3.0",
                        "isbn13": "9781617291609",
                        "price": "$32.10",
                        "image": "https://itbook.store/img/books/9781617291609.png",
                        "url": "https://itbook.store/books/9781617291609"
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
            XCTAssertTrue(bookPage.total == "48")
            XCTAssertTrue(!bookPage.books.isEmpty)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
