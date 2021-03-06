//
//  File.swift
//  
//
//  Created by 육찬심 on 2021/12/27.
//

import Combine
import UseCases
import Entities
import Foundation

public protocol SearchBooksResultFlowDelegate {
    
    func showDetail(book: Book)
}

public protocol SearchBooksResultViewModelAction {
    
    func search(query: String)
    func cancel()
    func loadNextPage()
    func select(book: Book)
}

public protocol SearchBooksResultViewModelState {
    
    var searchedBooks: CurrentValueSubject<[Book], Error> { get }
}

public protocol SearchBooksResultViewModelType {
    
    var action: SearchBooksResultViewModelAction { get }
    var state: SearchBooksResultViewModelState { get }
}

public final class SearchBooksResultViewModel: SearchBooksResultViewModelAction, SearchBooksResultViewModelState {
    
    private let searchBooksUseCase: SearchBooksUseCase
    private let flowDelegate: SearchBooksResultFlowDelegate
    
    public var searchedBooks: CurrentValueSubject<[Book], Error> = CurrentValueSubject([])
    
    private var query: String = ""
    private var currentPage: BookPage?
    private var totalCount: Int { Int(currentPage?.total ?? "") ?? 0 }
    private var itemCount: Int { searchedBooks.value.count }
    private var hasMorePage: Bool { totalCount > itemCount }
    private let pageController = PageController<Result<BookPage, Error>>()
    
    public init(
        searchBooksUseCase: SearchBooksUseCase,
        flowDelegate: SearchBooksResultFlowDelegate
    ) {
        self.searchBooksUseCase = searchBooksUseCase
        self.flowDelegate = flowDelegate
    }
    
    public func search(query: String) {
        self.query = query
        pageController.load { [weak self] page in
            guard let self = self else { return }
            do {
                let bookPage = try await self.searchBooksUseCase.execute(query: query, page: page).get()
                self.searchedBooks.value = bookPage.books
                self.currentPage = bookPage
            } catch {
                NSLog(error.localizedDescription)
            }
        }
    }
    
    public func loadNextPage() {
        pageController.loadNext(pageInfo: PageInfo(hasMorePage: hasMorePage, load: { [weak self] page in
            guard let self = self else { return }
            do {
                let bookPage = try await self.searchBooksUseCase.execute(query: self.query, page: page).get()
                var books = self.searchedBooks.value
                books.append(contentsOf: bookPage.books)
                self.searchedBooks.value = books
                self.currentPage = bookPage
            } catch {
                NSLog(error.localizedDescription)
            }
        }))
    }
    
    public func cancel() {
        currentPage = nil
        searchedBooks.value = []
    }
    
    public func select(book: Book) {
        flowDelegate.showDetail(book: book)
    }
}


extension SearchBooksResultViewModel: SearchBooksResultViewModelType {
    
    public var action: SearchBooksResultViewModelAction { self }
    public var state: SearchBooksResultViewModelState { self }
}
