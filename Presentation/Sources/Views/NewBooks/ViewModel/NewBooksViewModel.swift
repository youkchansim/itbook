//
//  SearchBooksViewModel.swift
//  
//
//  Created by 육찬심 on 2021/12/26.
//

import Combine
import UseCases
import Entities
import Foundation

public protocol NewBooksFlowDelegate {
    
    func showDetail(book: Book)
}

public protocol NewBooksViewModelAction {
    
    func loadNewBooks()
    func select(book: Book)
}

public protocol NewBooksViewModelState {
    
    var newBooks: CurrentValueSubject<[Book], Error> { get }
}

public protocol NewBooksViewModelType {
    
    var action: NewBooksViewModelAction { get }
    var state: NewBooksViewModelState { get }
}

public final class NewBooksViewModel: NewBooksViewModelAction, NewBooksViewModelState {
    
    private let newBooksUseCase: NewBooksUseCase
    private let flowDelegate: NewBooksFlowDelegate
    
    public var newBooks: CurrentValueSubject<[Book], Error> = CurrentValueSubject([])
    
    public init(
        newBooksUseCase: NewBooksUseCase,
        flowDelegate: NewBooksFlowDelegate
    ) {
        self.newBooksUseCase = newBooksUseCase
        self.flowDelegate = flowDelegate
    }
    
    public func loadNewBooks() {
        Task {
            do {
                newBooks.value = try await newBooksUseCase.execute().get()
            } catch {
                NSLog(error.localizedDescription)
            }
        }
    }
    
    public func select(book: Book) {
        flowDelegate.showDetail(book: book)
    }
}


extension NewBooksViewModel: NewBooksViewModelType {
    
    public var action: NewBooksViewModelAction { self }
    public var state: NewBooksViewModelState { self }
}
