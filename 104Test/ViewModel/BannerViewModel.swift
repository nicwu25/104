//
//  ADViewModel.swift
//  104Test
//
//  Created by Nic Wu on 2023/5/17.
//

import Foundation

class BannerViewModel {
    
    @Published var bannerList: AdList?
    
    func numberOfItemsAdList() -> Int {
        bannerList?.list.count ?? 0
    }
    
    func getBannerItem(index: Int) -> Ad? {
        if let bannerList, bannerList.list.indices.contains(index) {
            return bannerList.list[index]
        }
        return nil
    }
}
