//
//  NetworkRequestableMock.swift
//  
//
//  Created by 육찬심 on 2021/12/26.
//

import Network
import Foundation

struct ResponseMock: Decodable {
    
}

class NetworkRequestableMock: NetworkRequestable {
    
    enum MockError: Error {
        
        case mockError
    }
    
    var requestCallCount = 0
    
    func request<T>(target: RequestTarget) async -> Result<T, Error> where T : Decodable {
        requestCallCount += 1
        return .failure(MockError.mockError)
    }
    
    func request(from url: URL) async -> Result<Data, Error> {
        requestCallCount += 1
        return .failure(MockError.mockError)
    }
}
