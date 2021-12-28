//
//  FlowCoordinator.swift
//  
//
//  Created by 육찬심 on 2021/12/27.
//

import Foundation
import UIKit

public final class FlowCoordinator {
    
    private let container: AppDIContainer
    private let navigationController = UINavigationController()
    
    private lazy var searchBooksCoordinator: SearchBooksCoordinator = {
        SearchBooksCoordinator(navigationController: navigationController, dependency: container.searchBooksDIContainer, detailBookFlowDelegate: detailBookCoordinator)
    }()
    
    private lazy var detailBookCoordinator: DetailBookCoordinator = {
        DetailBookCoordinator(navigationController: navigationController, dependency: container.detailBookDIContainer)
    }()
    
    public init(container: AppDIContainer) {
        self.container = container
    }
    
    public func launchViewController() -> UIViewController {
        let newBooksViewController = container.searchBooksDIContainer.makeNewBooksViewController(flowDelegate: searchBooksCoordinator)
        newBooksViewController.resultViewController = container.searchBooksDIContainer.makeSearchBooksResultViewController(flowDelegate: searchBooksCoordinator)
        self.navigationController.pushViewController(newBooksViewController, animated: false)
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }
}
