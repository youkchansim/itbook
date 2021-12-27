//
//  File.swift
//  
//
//  Created by 육찬심 on 2021/12/26.
//

import Entities

public struct BookDTO: Decodable {
    
    public let title: String
    public let subtitle: String
    public let price: String
    public let image: String
    public let url: String
    public let isbn13: String
    public let isbn10: String?
    public let error: String?
    public let authors: String?
    public let publisher: String?
    public let pages: String?
    public let year: String?
    public let rating: String?
    public let desc: String?
    public let pdf: [String: String]?
}

public extension BookDTO {
    
    func toBook() -> Book {
        return Book(title: title,
                    subtitle: subtitle,
                    price: price,
                    image: image,
                    url: url,
                    isbn10: isbn10 ?? "",
                    isbn13: isbn13,
                    error: error ?? "",
                    authors: authors ?? "",
                    publisher: publisher ?? "",
                    pages: pages ?? "",
                    year: year ?? "",
                    rating: rating ?? "",
                    desc: desc ?? "",
                    pdf: pdf ?? [:])
    }
}
