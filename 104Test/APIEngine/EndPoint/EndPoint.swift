//
//  EndPoint.swift
//  104Test
//
//  Created by Nic Wu on 2023/5/11.
//

import Alamofire

protocol EndPoint {
    var baseURL: String { get }
    var endPoint: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any] { get }
    var encoding: ParameterEncoding { get }
    var headers: HTTPHeaders? { get }
}

extension EndPoint {
    
    var baseURL: String {
        AppConstant.domain
    }
    
    var headers: HTTPHeaders? {
        nil
    }
    
    var encoding: Alamofire.ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
}

