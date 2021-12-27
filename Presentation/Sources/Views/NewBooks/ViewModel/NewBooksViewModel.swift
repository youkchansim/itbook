//
//  SearchBooksViewModel.swift
//  
//
//  Created by 육찬심 on 2021/12/26.
//

import Combine
import UseCases
import Entities

public protocol NewBooksViewModelAction {
    
    func loadNewBooks()
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
    
    public var newBooks: CurrentValueSubject<[Book], Error> = CurrentValueSubject([])
    
    public init(
        newBooksUseCase: NewBooksUseCase
    ) {
        self.newBooksUseCase = newBooksUseCase
    }
    
    public func loadNewBooks() {
        Task {
            do {
                newBooks.value = try await newBooksUseCase.execute().get()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}


extension NewBooksViewModel: NewBooksViewModelType {
    
    public var action: NewBooksViewModelAction { self }
    public var state: NewBooksViewModelState { self }
}
