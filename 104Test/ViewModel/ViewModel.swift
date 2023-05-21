//
//  ViewModel.swift
//  104Test
//
//  Created by Nic Wu on 2023/5/12.
//

import Foundation

class ViewModel {
    
    private let repository: ViewRepository
    
    private var isFetching: Bool = false
    
    private var jobData: JobData?
    
    private var page: Int {
        guard let jobData else { return 0 }
        return Int(jobData.page) ?? 0
    }
    
    private var haveNextPage: Bool {
        guard let jobData else { return true }
        return jobData.page < jobData.pageSize
    }
    
    @Published var bannerList: AdList?
    
    @Published var jobList: [JobViewObject] = []
    
    var sections: [Section] {
        Section.allCases
    }
    
    var numberOfSections: Int {
        sections.count
    }
    
    var menuItems: [MenuItem] = [.recommend, .new]
    
    @Published var selectedMenuItem: MenuItem = .recommend
    
    @Published var ad1List: [AD1ViewObject] = [AD1ViewObject(image: "", title: "我是哪種型"),
                                               AD1ViewObject(image: "", title: "測薪水行情"),
                                               AD1ViewObject(image: "", title: "雙北高薪職缺"),
                                               AD1ViewObject(image: "", title: "產業人才培訓")]
    init() {
        repository = ViewRepositoryImpl()
    }
    
    func numberOfItemsInSection(index: Int) -> Int {
        guard let section = getSection(index: index) else { return 0 }
        switch section {
        case .ad1:
            return ad1List.count
        case .menu:
            return menuItems.count
        case .job:
            return jobList.count
        }
    }
    
    func getSection(index: Int) -> Section? {
        if sections.indices.contains(index) {
            return sections[index]
        }
        return nil
    }
    
    func getMenuItem(index: Int) -> MenuItem? {
        if menuItems.indices.contains(index) {
            return menuItems[index]
        }
        return nil
    }
}

extension ViewModel {
    
    func fetchJobList() async throws {
        guard !isFetching, haveNextPage else { return }
        isFetching = true
        let data = try await repository.fetchJobList(page: page + 1)
        jobData = data
        bannerList = data.ad
        jobList.append(contentsOf: data.list.map{ $0.toViewObject() })
        isFetching = false
    }
    
    func refreshJobList() async throws {
        guard !isFetching else { return }
        isFetching = true
        let data = try await repository.refreshJobList(page: 1)
        jobData = data
        bannerList = data.ad
        jobList = data.list.map{ $0.toViewObject() }
        isFetching = false
    }
}

extension ViewModel {
    
    enum Section: CaseIterable {
        /// 我是哪種型/測薪水行情...
        case ad1
        /// 推薦/最新
        case menu
        /// 工作列表
        case job
    }
    
    enum MenuItem: CaseIterable {
        case recommend, new
        
        var title: String {
            switch self {
            case .recommend:
                return "推薦"
            case .new:
                return "最新"
            }
        }
    }
}

extension Job {
    func toViewObject() -> JobViewObject {
        JobViewObject(title: job,
                      company: name,
                      salary: salary,
                      experience: period,
                      location: jobAddrNoDescript,
                      date: appearDateUTC,
                      isFavorite: false)
    }
}
