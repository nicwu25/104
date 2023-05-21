//
//  CellConfiguratorVisitor.swift
//  104Test
//
//  Created by Nic Wu on 2023/5/13.
//

import UIKit

struct CellConfiguratorVisitor: Visitor {
    
    let collectionView: UICollectionView
    let indexPath: IndexPath

    func visit(_ viewObject: AD1ViewObject) -> UICollectionViewCell? {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AD1CollectionViewCell.reuseIdentifier, for: indexPath) as! AD1CollectionViewCell
        cell.imageView.sd_setImage(with: URL(string: viewObject.image))
        cell.titleLabel.text = viewObject.title
        return cell
    }
    
    func visit(_ viewObject: MenuViewObject) -> UICollectionViewCell? {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCollectionViewCell.reuseIdentifier, for: indexPath) as! MenuCollectionViewCell
        cell.titleLabel.text = viewObject.item.title
        cell.updateSelect(viewObject.isSelected)
        return cell
    }

    func visit(_ viewObject: JobViewObject) -> UICollectionViewCell? {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JobCollectionViewCell.reuseIdentifier, for: indexPath) as! JobCollectionViewCell
        cell.titleLabel.text = viewObject.title
        cell.companyLabel.text = viewObject.company
        cell.salaryLabel.text = viewObject.salary
        cell.experienceLabel.text = viewObject.experience
        cell.locationLabel.text = viewObject.location
        cell.dateLabel.text = DateUtility.getCreateTimeString(Double(viewObject.date) ?? Date().timeIntervalSince1970)
        return cell
    }
}
