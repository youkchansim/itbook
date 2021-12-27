//
//  PageController.swift
//  
//
//  Created by 육찬심 on 2021/12/27.
//

import Foundation

public typealias Load = (Int) async -> Void

public struct PageInfo<T> {
    
    public let hasMorePage: Bool
    public let load: Load
    
    public init(
        hasMorePage: Bool,
        load: @escaping Load
    ) {
        self.hasMorePage = hasMorePage
        self.load = load
    }
}

public class PageController<T> {
    
    private var isLoading = false
    
    private var currentPage = 1
    private var nextPage: Int { currentPage + 1 }
    
    public init() { }
    
    func load(_ closure: @escaping Load) {
        guard !isLoading else { return }
        isLoading = true
        Task {
            defer {
                currentPage += 1
                isLoading = false
            }
            await closure(currentPage)
        }
    }
    
    func loadNext(pageInfo: PageInfo<T>) {
        guard !isLoading else { return }
        guard pageInfo.hasMorePage else { return }
        isLoading = true
        Task {
            defer {
                currentPage += 1
                isLoading = false
            }
            await pageInfo.load(nextPage)
        }
    }
}
