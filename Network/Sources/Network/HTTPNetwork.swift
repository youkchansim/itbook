//
//  HTTPNetwork.swift
//  
//
//  Created by 육찬심 on 2021/12/26.
//

import Foundation
import Alamofire

public enum NetworkError: Error {
    
    case invalidURL
}

public protocol RequestTarget: URLConvertible {
    
    var baseURLString: String { get }
    var path: String { get }
    var headers: Alamofire.HTTPHeaders { get }
    var bodyPrameters: Alamofire.Parameters? { get }
    var method: Alamofire.HTTPMethod { get }
    var parameterEncoding: Alamofire.ParameterEncoding { get }
    
    var timeoutInterval: TimeInterval { get }
}

public extension RequestTarget {
    
    func asURL() throws -> URL {
        guard let url = URL(string: baseURLString)?.appendingPathComponent(path) else {
            throw NetworkError.invalidURL
        }
        return url
    }
}

public protocol NetworkRequestable {
    
    func request<T: Decodable>(target: RequestTarget) async -> Result<T, Error>
}

public struct HTTPNetwork: NetworkRequestable {
    
    private let session = URLSession.shared
    
    public init() {}

    public func request<T: Decodable>(target: RequestTarget) async -> Result<T, Error> {
        let response = AF.request(target,
                                  method: target.method,
                                  parameters: target.bodyPrameters,
                                  encoding: target.parameterEncoding,
                                  headers: target.headers)
            .serializingDecodable(T.self)
        
        let result = await response.result
        switch result {
        case .success(let value): return .success(value)
        case .failure(let error): return .failure(error)
        }
    }
}
