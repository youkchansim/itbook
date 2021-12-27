//
//  ImageProvider.swift
//  
//
//  Created by 육찬심 on 2021/12/27.
//

import Cache
import UIKit
import Network
import Alamofire

public class ImageProvider {
    
    public enum ImageError: Error {
        
        case invalidData
    }
    
    public static let shared: ImageProvider = ImageProvider(networkRequestable: HTTPNetwork(), memCacher: MemoryCacher(capacity: 30), localCacher: LocalCacher())
    
    private let memCacher: ImageCachable
    private let localCacher: ImageCachable
    private let networkRequestable: NetworkRequestable
    
    public init(networkRequestable: NetworkRequestable, memCacher: ImageCachable, localCacher: ImageCachable) {
        self.networkRequestable = networkRequestable
        self.memCacher = memCacher
        self.localCacher = localCacher
    }
    
    public func fetchImage(with url: URL) async -> Result<(URL, UIImage?), Error> {
        let key = hash(url)
        if let image = memCacher.get(key: key) {
            return .success((url, image))
        }
        
        if let image = localCacher.get(key: key) {
            self.memCacher.add(key: key, value: image)
            return .success((url, image))
        }
        
        let result: Result<Data, Error> = await networkRequestable.request(from: url)
        switch result {
        case .success(let data):
            if let image = UIImage(data: data) {
                self.memCacher.add(key: key, value: image)
                self.localCacher.add(key: key, value: image)
                return .success((url, image))
            } else {
                return .failure(ImageError.invalidData)
            }
        case .failure(let error): return .failure(error)
        }
    }
    
    private func hash(_ url: URL) -> String {
        return "\(url.absoluteString.hashValue)"
    }
}
