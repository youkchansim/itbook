//
//  Book.swift
//  
//
//  Created by 육찬심 on 2021/12/26.
//

import Foundation

public struct Book {
    
    public let title: String
    public let subtitle: String
    public let price: String
    public let image: String
    public let url: String
    public let isbn10: String
    public let isbn13: String
    public let error: String
    public let authors: String
    public let publisher: String
    public let pages: String
    public let year: String
    public let rating: String
    public let desc: String
    public let pdf: String
    
    public init(
        title: String,
        subtitle: String,
        price: String,
        image: String,
        url: String,
        isbn10: String = "",
        isbn13: String,
        error: String = "",
        authors: String = "",
        publisher: String = "",
        pages: String = "",
        year: String = "",
        rating: String = "",
        desc: String = "",
        pdf: String = ""
    ) {
        self.title = title
        self.subtitle = subtitle
        self.price = price
        self.image = image
        self.url = url
        self.isbn10 = isbn10
        self.isbn13 = isbn13
        self.error = error
        self.authors = authors
        self.publisher = publisher
        self.pages = pages
        self.year = year
        self.rating = rating
        self.desc = desc
        self.pdf = pdf
    }
}

public struct BookPage {
    
    public let total: String
    public let page: String
    public let books: [Book]
    
    public init(
        total: String,
        page: String,
        books: [Book]
    ) {
        self.total = total
        self.page = page
        self.books = books
    }
}
