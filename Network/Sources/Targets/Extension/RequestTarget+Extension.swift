//
//  File.swift
//  
//
//  Created by 육찬심 on 2021/12/26.
//

import Network
import Alamofire
import Foundation

public extension RequestTarget {
    
    var baseURLString: String { "https://api.itbook.store/1.0" }
    
    var headers: Alamofire.HTTPHeaders { [
        .contentType("JSON")
    ] }
    
    var bodyPrameters: Parameters? { nil }
    
    var method: HTTPMethod { .get }
    
    var parameterEncoding: ParameterEncoding { URLEncoding.default }
    
    var timeoutInterval: TimeInterval { 30 }
}
