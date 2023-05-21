//
//  Visitable.swift
//  104Test
//
//  Created by Nic Wu on 2023/5/13.
//

import UIKit

protocol Visitable {
    @discardableResult func accept<V: Visitor>(visitor: V) -> V.T?
}

struct AD1ViewObject: Visitable, Hashable {
    let image: String
    let title: String
    
    func accept<V>(visitor: V) -> V.T? where V: Visitor {
        return visitor.visit(self)
    }
}

struct MenuViewObject: Visitable, Hashable {
    let item: ViewModel.MenuItem
    let isSelected: Bool
    
    func accept<V>(visitor: V) -> V.T? where V: Visitor {
        return visitor.visit(self)
    }
}

struct JobViewObject: Visitable, Hashable {
    let uuid = UUID()
    let title: String
    let company: String
    let salary: String
    let experience: String
    let location: String
    let date: String
    let isFavorite: Bool
    
    func accept<V>(visitor: V) -> V.T? where V: Visitor {
        return visitor.visit(self)
    }
}
