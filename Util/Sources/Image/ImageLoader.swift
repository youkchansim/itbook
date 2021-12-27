//
//  File.swift
//  
//
//  Created by 육찬심 on 2021/12/27.
//

import UIKit

public struct ImageLoader<Base> {
    
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

public protocol ImageLoaderCompatible: AnyObject {}

public extension ImageLoaderCompatible {

    var cs: ImageLoader<Self> {
        get { return ImageLoader(self) }
        set { }
    }
}

extension UIImageView: ImageLoaderCompatible { }

func getAssociatedObject<T>(_ object: Any, _ key: UnsafeRawPointer) -> T? {
    return objc_getAssociatedObject(object, key) as? T
}

func setAssociatedObject<T>(_ object: Any, _ key: UnsafeRawPointer, _ value: T) {
    objc_setAssociatedObject(object, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
}

extension UIImageView {
    
    fileprivate struct AssociatedObjectKeys {
        static var identifierKey = "identifier"
    }
    
    fileprivate(set) var identifier: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectKeys.identifierKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectKeys.identifierKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

public extension ImageLoader where Base: UIImageView {
    
    func setImage(_ url: URL?, placeHolderImage: UIImage?, animated: Bool = true) {
        guard let url = url else {
            base.identifier = nil
            return
        }
        
        base.identifier = url.absoluteString
        base.image = placeHolderImage
        
        Task {
            let result = await ImageProvider.shared.fetchImage(with: url)
            switch result {
            case .success(let (url, image)):
                DispatchQueue.main.async {
                    if url.absoluteString == self.base.identifier {
                        UIView.transition(with: self.base, duration: animated ? 0.3 : 0, options: [.transitionCrossDissolve, .allowUserInteraction], animations: {
                            self.base.image = image
                        }, completion: nil)
                    }
                }
            case .failure: break
            }
        }
    }
}
