//
//  AppDIContainer.swift
//  
//
//  Created by 육찬심 on 2021/12/27.
//

import Foundation
import Network

public final class AppDIContainer {
    
    public init() { }
    
    lazy var networkRequestable: NetworkRequestable = {
        HTTPNetwork()
    }()
    
    lazy var searchBooksDIContainer: SearchBooksDIContainer = {
        SearchBooksDIContainer(dependency: .init(networkRequestable: networkRequestable))
    }()
    
    lazy var detailBookDIContainer: DetailBookDIContainer = {
        DetailBookDIContainer(dependency: .init(networkRequestable: networkRequestable))
    }()
}
