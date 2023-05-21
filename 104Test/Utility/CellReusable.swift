//
//  CellReusable.swift
//  104Test
//
//  Created by Nic Wu on 2023/5/11.
//

import UIKit

protocol CellReusable {}

extension CellReusable where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static var cellNib: UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
}

extension UITableViewCell: CellReusable {}
extension UITableViewHeaderFooterView: CellReusable {}
extension UICollectionViewCell: CellReusable {}
extension UICollectionReusableView: CellReusable {}
