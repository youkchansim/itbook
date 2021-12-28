//
//  DetailBookCoordinator.swift
//  
//
//  Created by 육찬심 on 2021/12/28.
//

import Foundation
import Views
import UIKit
import Entities

protocol DetailBooksCoordinatorDependency {
    
    func makePDFViewer(_ title: String, url: URL) -> UIViewController
    func makeWebViewer(_ url: URL) -> UIViewController
}

final class DetailBookCoordinator {
    
    private let navigationController: UINavigationController
    private let dependency: DetailBooksCoordinatorDependency
    
    public init(
        navigationController: UINavigationController,
        dependency: DetailBooksCoordinatorDependency
    ) {
        self.navigationController = navigationController
        self.dependency = dependency
    }
}

extension DetailBookCoordinator: DetailBookFlowDelegate {
    
    func showPurchase(_ url: URL) {
        let webViewer = dependency.makeWebViewer(url)
        navigationController.pushViewController(webViewer, animated: true)
    }
    
    func showPDF(_ title: String, url: URL) {
        let pdfViewer = dependency.makePDFViewer(title, url: url)
        navigationController.pushViewController(pdfViewer, animated: true)
    }
}
