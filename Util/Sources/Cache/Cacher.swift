//
//  cacher.swift
//  
//
//  Created by 육찬심 on 2021/12/27.
//

import UIKit

public class LocalCacher: ImageCachable {
    
    public init() {
        prepareDirectory()
    }
    
    private var cacheDirectory: URL {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("Images")
    }
    
    private func prepareDirectory() {
        let cachePath = cacheDirectory
        var isDir : ObjCBool = false
        if !FileManager.default.fileExists(atPath: cachePath.path, isDirectory: &isDir) {
            do {
                try FileManager.default.createDirectory(at: cachePath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                NSLog(error.localizedDescription)
            }
        }
    }
    
    public func add(key: String, value: UIImage) {
        let data = value.pngData()
        let encodedKey = encode(key)
        let url = cacheDirectory.appendingPathComponent(encodedKey)
        do {
            try data?.write(to: url, options: .atomic)
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    public func get(key: String) -> UIImage? {
        let encodedKey = encode(key)
        let url = cacheDirectory.appendingPathComponent(encodedKey)
        if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            return image
        }
        return nil
    }
    
    public func remove(key: String) {
        let encodedKey = encode(key)
        let path = cacheDirectory.appendingPathComponent(encodedKey).path
        do {
            try FileManager.default.removeItem(atPath: path)
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    public func removeAll() {
        do {
            try FileManager.default.removeItem(at: cacheDirectory)
            prepareDirectory()
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    private func encode(_ string: String) -> String {
        return "\(string.hashValue)"
    }
}

public class MemoryCacher: ImageCachable {
    
    private let lock = NSLock()
    private let memCache = NSCache<NSString, UIImage>()
    
    public init(capacity: Int) {
        memCache.countLimit = capacity
    }
    
    public func add(key: String, value: UIImage) {
        lock.lock()
        memCache.setObject(value, forKey: key as NSString)
        lock.unlock()
    }
    
    public func get(key: String) -> UIImage? {
        return memCache.object(forKey: key as NSString)
    }
    
    public func remove(key: String) {
        lock.lock()
        memCache.removeObject(forKey: key as NSString)
        lock.unlock()
    }
    
    public func removeAll() {
        lock.lock()
        memCache.removeAllObjects()
        lock.unlock()
    }
}
