//
//  DetailBookDIContainer.swift
//  
//
//  Created by 육찬심 on 2021/12/28.
//

import UIKit
import Views
import Network
import SafariServices

final class DetailBookDIContainer {
    
    struct Dependency {
        
        let networkRequestable: NetworkRequestable
    }
    
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
}

extension DetailBookDIContainer: DetailBooksCoordinatorDependency {
    
    func makePDFViewer(_ title: String, url: URL) -> UIViewController {
        return SFSafariViewController(url: url)
    }
    
    func makeWebViewer(_ url: URL) -> UIViewController {
        return SFSafariViewController(url: url)
    }
}
