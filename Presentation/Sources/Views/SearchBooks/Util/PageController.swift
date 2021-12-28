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
    
    var isLoading = false
    
    var currentPage = 1
    private var nextPage: Int { currentPage + 1 }
    private var task: Task<(), Never>?
    private var nextTask: Task<(), Never>?
    
    public init() { }
    
    func load(_ closure: @escaping Load) {
        guard !isLoading else { return }
        currentPage = 1
        isLoading = true
        cancel()
        task = Task {
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
        cancelNext()
        nextTask = Task {
            defer {
                currentPage += 1
                isLoading = false
            }
            await pageInfo.load(nextPage)
        }
    }
    
    func cancel() {
        task?.cancel()
        task = nil
        nextTask?.cancel()
        nextTask = nil
        isLoading = false
    }
    
    func cancelNext() {
        nextTask?.cancel()
        nextTask = nil
        isLoading = false
    }
}
