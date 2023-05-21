//
//  ViewRepositoryImpl.swift
//  104Test
//
//  Created by Nic Wu on 2023/5/13.
//

import Foundation

class ViewRepositoryImpl: ViewRepository {
    
    private let dataSource = APIEngine()
    
    private let cache = Cache<String, JobData>(entryLifetime: 60 * 5)
    
    private let id = "JobList"
    
    func fetchJobList(page: Int) async throws -> JobData {
        let id = "\(self.id)\(page)"
        if let cached = cache[id] {
            return cached
        }
        let jobData = try await dataSource.getJobList(page: page)
        cache[id] = jobData
        return jobData
    }
    
    func refreshJobList(page: Int) async throws -> JobData {
        let id = "\(self.id)\(page)"
        let jobData = try await dataSource.getJobList(page: page)
        cache[id] = jobData
        return jobData
    }
}
