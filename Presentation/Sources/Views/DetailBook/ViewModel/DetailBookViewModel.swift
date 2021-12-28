//
//  DetailBookViewModel.swift
//  
//
//  Created by 육찬심 on 2021/12/26.
//

import Combine
import Entities
import UseCases
import Foundation

public protocol DetailBookFlowDelegate {
    
    func showPurchase(_ url: URL)
    func showPDF(_ title: String, url: URL)
}

public protocol DetailBookViewModelAction {
    
    func load()
    func purchase()
    func select(pdf: (title: String, url: String))
}

public protocol DetailBookViewModelState {
    
    var book: CurrentValueSubject<Book, Error> { get }
}

public protocol DetailBookViewModelType {
    
    var action: DetailBookViewModelAction { get }
    var state: DetailBookViewModelState { get }
}

public class DetailBookViewModel: DetailBookViewModelAction, DetailBookViewModelState {
    
    private let detailBookUseCase: DetailBookUseCase
    private let flowDelegate: DetailBookFlowDelegate
    
    public let book: CurrentValueSubject<Book, Error>
    
    public init(
        book: Book,
        detailBookUseCase: DetailBookUseCase,
        flowDelegate: DetailBookFlowDelegate
    ) {
        self.book = CurrentValueSubject(book)
        self.detailBookUseCase = detailBookUseCase
        self.flowDelegate = flowDelegate
    }
    
    public func load() {
        Task {
            do {
                book.value = try await detailBookUseCase.execute(book: book.value).get()
            } catch {
                NSLog(error.localizedDescription)
            }
        }
    }
    
    public func purchase() {
        if let url = URL(string: book.value.url) {
            flowDelegate.showPurchase(url)
        }
    }
    
    public func select(pdf: (title: String, url: String)) {
        if let url = URL(string: pdf.url) {
            flowDelegate.showPDF(pdf.title, url: url)
        }
    }
}

extension DetailBookViewModel: DetailBookViewModelType {
    
    public var action: DetailBookViewModelAction { self }
    public var state: DetailBookViewModelState { self }
}
