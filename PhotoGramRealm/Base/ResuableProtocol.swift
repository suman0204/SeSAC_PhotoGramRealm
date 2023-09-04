//
//  ResuableProtocol.swift
//  PhotoGramRealm
//
//  Created by jack on 2023/09/03.
//

import UIKit

protocol ReusableViewProtocol: AnyObject { // AnyObject: 클래스에만 채택할 수 있다
    static var reuseIdentifier: String { get }
    
}

// 하나의 모듈에서 사용되기 때문에 public은 사용x
extension UIViewController: ReusableViewProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: ReusableViewProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
extension UITableViewCell: ReusableViewProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

