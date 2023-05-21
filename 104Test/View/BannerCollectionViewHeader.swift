//
//  ADCollectionViewHeader.swift
//  104Test
//
//  Created by Nic Wu on 2023/5/17.
//

import UIKit

class BannerCollectionViewHeader: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func add(childVC vc: UIViewController, toParent parentVC: UIViewController) {
        addSubview(vc.view)
        parentVC.addChild(vc)
        vc.didMove(toParent: parentVC)
        vc.view.frame = self.frame
    }
}
