//
//  APIEngine+Job.swift
//  104Test
//
//  Created by Nic Wu on 2023/5/11.
//

import Foundation

extension APIEngine {
    
    func getJobList(page: Int) async throws -> JobData {
        let response: JobResponse = try await requestAsyncDecodable(endPoint: JobAPI.getList(page: page))
        if let error = response.err {
            throw NetworkError.failure(statusCode: error.errCode, message: error.errMsg)
        }
        return response.data
    }
    
    func getJobDetail(id: String, source: String) async throws -> JobResponse {
        try await requestAsyncDecodable(endPoint: JobAPI.getDetail(id: id, source: source))
    }
}
