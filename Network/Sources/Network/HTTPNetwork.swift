//
//  HTTPNetwork.swift
//  
//
//  Created by 육찬심 on 2021/12/26.
//

import Alamofire

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
