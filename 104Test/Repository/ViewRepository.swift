//
//  ViewRepository.swift
//  104Test
//
//  Created by Nic Wu on 2023/5/13.
//

import Foundation

protocol ViewRepository {
    func fetchJobList(page: Int) async throws -> JobData
    func refreshJobList(page: Int) async throws -> JobData
}
