//
//  ImageProviderTests.swift
//  
//
//  Created by 육찬심 on 2021/12/27.
//

import XCTest
import Image
import Cache
import Network
import Extension

class ImageProviderTests: XCTestCase {
    
    class NetworkMock: NetworkRequestable {
        
        enum ErrorMock: Error {
            
            case errorMock
        }
        
        var callCount = 0
        
        func request<T: Decodable>(target: RequestTarget) async -> Result<T, Error> {
            return .failure(ErrorMock.errorMock)
        }
        
        func request(from url: URL) async -> Result<Data, Error> {
            callCount += 1
            if let data = UIImage(systemName: "book")?.pngData() {
                return .success(data)
            } else {
                return .failure(ErrorMock.errorMock)
            }
        }
    }
    
    class CacherMock: ImageCachable {
        
        var addCallCount = 0
        var getCallCount = 0
        var removeCallCount = 0
        var removeAllCallCount = 0
        
        private var image: UIImage?
        
        func add(key: String, value: UIImage) {
            addCallCount += 1
            image = value
        }
        
        func get(key: String) -> UIImage? {
            getCallCount += 1
            return image
        }
        
        func remove(key: String) {
            removeCallCount += 1
            image = nil
        }
        
        func removeAll() {
            removeAllCallCount += 1
            image = nil
        }
    }
    
    func test_imageProvider_whenInitialFetch_thenNetworkCallCountIsOne() {
        let networkMock = NetworkMock()
        let memoryCacher = CacherMock()
        let localCacher = CacherMock()
        let sut = ImageProvider(networkRequestable: networkMock, memCacher: memoryCacher, localCacher: localCacher)
        
        // when
        if let url = URL(string: "http://test.com") {
            asyncTest {
                _ = try? await sut.fetchImage(with: url).get()
            }
        }
        
        XCTAssertTrue(memoryCacher.getCallCount == 1, "Called momoryCacher's add fuction - \(memoryCacher.getCallCount)")
        XCTAssertTrue(localCacher.getCallCount == 1, "Called localCacher's add fuction - \(localCacher.getCallCount)")
        XCTAssertTrue(networkMock.callCount == 1, "Called Cachable")
        XCTAssertTrue(memoryCacher.addCallCount == 1, "Should add memory - \(memoryCacher.addCallCount)")
        XCTAssertTrue(localCacher.addCallCount == 1, "Should add local - \(localCacher.addCallCount)")
    }
    
    func test_imageProvider_whenCachedFetch_thenFetchedFromMemory() {
        let networkMock = NetworkMock()
        let memoryCacher = CacherMock()
        let localCacher = CacherMock()
        let sut = ImageProvider(networkRequestable: networkMock, memCacher: memoryCacher, localCacher: localCacher)
        
        // when
        if let url = URL(string: "http://test.com") {
            asyncTest {
                _ = try? await sut.fetchImage(with: url).get()
                _ = try? await sut.fetchImage(with: url).get()
            }
        }
        
        XCTAssertTrue(memoryCacher.getCallCount == 2, "Called momoryCacher's add fuction - \(memoryCacher.getCallCount)")
        XCTAssertTrue(localCacher.getCallCount == 1, "Called localCacher's add fuction - \(localCacher.getCallCount)")
        XCTAssertTrue(networkMock.callCount == 1, "Called Cachable")
    }
}
