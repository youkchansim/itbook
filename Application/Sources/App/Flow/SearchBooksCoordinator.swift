//
//  File.swift
//  
//
//  Created by 육찬심 on 2021/12/28.
//

import Foundation
import Views
import UIKit
import Entities

protocol SearchBooksCoordinatorDependency {
    
    func makeDetailBookViewController(book: Book, flowDelegate: DetailBookFlowDelegate) -> DetailBookViewController
}

final class SearchBooksCoordinator {
    
    private let navigationController: UINavigationController
    private let dependency: SearchBooksCoordinatorDependency
    private let detailBookFlowDelegate: DetailBookFlowDelegate
    
    public init(
        navigationController: UINavigationController,
        dependency: SearchBooksCoordinatorDependency,
        detailBookFlowDelegate: DetailBookFlowDelegate
    ) {
        self.navigationController = navigationController
        self.dependency = dependency
        self.detailBookFlowDelegate = detailBookFlowDelegate
    }
}

extension SearchBooksCoordinator: SearchBooksResultFlowDelegate, NewBooksFlowDelegate {
    
    func showDetail(book: Book) {
        navigationController.pushViewController(dependency.makeDetailBookViewController(book: book, flowDelegate: detailBookFlowDelegate), animated: true)
    }
}
