//
//  Visitor.swift
//  104Test
//
//  Created by Nic Wu on 2023/5/13.
//

import Foundation

protocol Visitor {
    associatedtype T
    func visit(_ viewObject: AD1ViewObject) -> T?
    func visit(_ viewObject: MenuViewObject) -> T?
    func visit(_ viewObject: JobViewObject) -> T?
}
