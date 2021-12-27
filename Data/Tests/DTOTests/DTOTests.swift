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
                "error": "0",
                "title": "Securing DevOps",
                "subtitle": "Security in the Cloud",
                "authors": "Julien Vehent",
                "publisher": "Manning",
                "isbn10": "1617294136",
                "isbn13": "9781617294136",
                "pages": "384",
                "year": "2018",
                "rating": "5",
                "desc": "An application running in the cloud can benefit from incredible efficiencies, but they come with unique security threats too. A DevOps team's highest priority is understanding those risks and hardening the system against them.Securing DevOps teaches you the essential techniques to secure your cloud ...",
                "price": "$26.98",
                "image": "https://itbook.store/img/books/9781617294136.png",
                "url": "https://itbook.store/books/9781617294136",
                "pdf": {
                          "Chapter 2": "https://itbook.store/files/9781617294136/chapter2.pdf",
                          "Chapter 5": "https://itbook.store/files/9781617294136/chapter5.pdf"
                       }
            }
        """.data(using: .utf8) else {
            XCTFail("Unsupport json string")
            return
        }
        
        do {
            let result = try JSONDecoder().decode(BookDTO.self, from: jsonData)
            let book = result.toBook()
            XCTAssertTrue(book.title == "Securing DevOps")
            XCTAssertTrue(book.pdf.keys.count == 2)
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
