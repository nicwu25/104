//
//  JobAPI.swift
//  104Test
//
//  Created by Nic Wu on 2023/5/11.
//

import Alamofire

enum JobAPI {
    case getList(page: Int)
    case getDetail(id: String, source: String)
}

extension JobAPI: EndPoint {
    var endPoint: String {
        switch self {
        case .getList(let page):
            return "2.0/job/search?device_type=0&device_id=12345678&app_version=2.37.0&page=\(page)"
        case .getDetail(let id, let source):
            return "2.0/job/info/\(id)?device_type=0&device_id=12345678&app_version=2.37.0&source=\(source)"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getList:
            return .post
        case .getDetail:
            return .get
        }
    }
    
    var parameters: [String : Any] {
        [:]
    }
}
