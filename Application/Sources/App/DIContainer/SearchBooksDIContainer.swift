//
//  File.swift
//  
//
//  Created by 육찬심 on 2021/12/27.
//

import Views
import Network
import Entities
import UseCases
import Interfaces
import Repositories

final class SearchBooksDIContainer {
    
    struct Dependency {
        
        let networkRequestable: NetworkRequestable
    }
    
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - NewBooks
    func makeNewBooksViewController(flowDelegate: NewBooksFlowDelegate) -> NewBooksViewController {
        let vc = NewBooksViewController.create()
        vc.viewModel = makeNewBooksViewModel(flowDelegate: flowDelegate)
        return vc
    }
    
    func makeNewBooksRepository() -> NewBooksRepository {
        return NewBooksRepositoryImp(networkRequestable: dependency.networkRequestable)
    }
    
    func makeNewBooksUseCase() -> NewBooksUseCase {
        return NewBooksUseCaseImp(repository: makeNewBooksRepository())
    }
    
    func makeNewBooksViewModel(flowDelegate: NewBooksFlowDelegate) -> NewBooksViewModelType {
        let newBooksUseCase = makeNewBooksUseCase()
        return NewBooksViewModel(newBooksUseCase: newBooksUseCase, flowDelegate: flowDelegate)
    }
    
    // MARK: - SearchBooks
    func makeSearchBooksResultViewController(flowDelegate: SearchBooksResultFlowDelegate) -> SearchBooksResultViewController {
        let vc = SearchBooksResultViewController.create()
        vc.viewModel = makeSearchBooksResultViewModel(flowDelegate: flowDelegate)
        return vc
    }
    
    func makeSearchBooksRepository() -> SearchBooksRepository {
        return SearchBooksRepositoryImp(networkRequestable: dependency.networkRequestable)
    }
    
    func makeSearchBooksUseCase() -> SearchBooksUseCase {
        return SearchBooksUseCaseImp(repository: makeSearchBooksRepository())
    }
    
    func makeSearchBooksResultViewModel(flowDelegate: SearchBooksResultFlowDelegate) -> SearchBooksResultViewModelType {
        let searchBooksUseCase = makeSearchBooksUseCase()
        return SearchBooksResultViewModel(searchBooksUseCase: searchBooksUseCase, flowDelegate: flowDelegate)
    }
    
    // MARK: - DetailBook
    func makeDetailBookViewController(book: Book, flowDelegate: DetailBookFlowDelegate) -> DetailBookViewController {
        let vc = DetailBookViewController.create()
        vc.viewModel = makeDetailBookViewModel(book: book, flowDelegate: flowDelegate)
        return vc
    }
    
    func makeDetailBookViewModel(book: Book, flowDelegate: DetailBookFlowDelegate) -> DetailBookViewModelType {
        return DetailBookViewModel(book: book, detailBookUseCase: makeDetailBookUseCase(), flowDelegate: flowDelegate)
    }
    
    func makeDetailBookRepository() -> DetailBookRepository {
        return DetailBookRepositoryImp(networkRequestable: dependency.networkRequestable)
    }
    
    func makeDetailBookUseCase() -> DetailBookUseCase {
        return DetailBookUseCaseImp(repository: makeDetailBookRepository())
    }
}

extension SearchBooksDIContainer: SearchBooksCoordinatorDependency {}
