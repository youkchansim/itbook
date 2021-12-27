//
//  File.swift
//  
//
//  Created by 육찬심 on 2021/12/27.
//

import Combine
import UseCases
import Entities

public protocol SearchBooksResultViewModelAction {
    
    func search(query: String)
    func cancel()
    func loadNextPage()
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
    
    public var searchedBooks: CurrentValueSubject<[Book], Error> = CurrentValueSubject([])
    
    private var query: String = ""
    private var currentPage: BookPage?
    private var totalCount: Int { Int(currentPage?.total ?? "") ?? 0 }
    private var itemCount: Int { searchedBooks.value.count }
    private var hasMorePage: Bool { totalCount > itemCount }
    private let pageController = PageController<Result<BookPage, Error>>()
    
    public init(
        searchBooksUseCase: SearchBooksUseCase
    ) {
        self.searchBooksUseCase = searchBooksUseCase
    }
    
    public func search(query: String) {
        self.query = query
        pageController.load { [weak self] page in
            guard let self = self else { return }
            await self.load(query: query, page: page)
        }
    }
    
    public func loadNextPage() {
        pageController.loadNext(pageInfo: PageInfo(hasMorePage: hasMorePage, load: { [weak self] page in
            guard let self = self else { return }
            await self.load(query: self.query, page: page)
        }))
    }
    
    public func cancel() {
        currentPage = nil
        searchedBooks.value = []
    }
    
    func load(query: String, page: Int) async {
        do {
            let bookPage = try await searchBooksUseCase.execute(query: query, page: page).get()
            var books = searchedBooks.value
            books.append(contentsOf: bookPage.books)
            searchedBooks.value = books
            currentPage = bookPage
        } catch {
            print(error.localizedDescription)
        }
    }
}


extension SearchBooksResultViewModel: SearchBooksResultViewModelType {
    
    public var action: SearchBooksResultViewModelAction { self }
    public var state: SearchBooksResultViewModelState { self }
}
