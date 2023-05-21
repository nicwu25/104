//
//  APIEngine.swift
//  104Test
//
//  Created by Nic Wu on 2023/5/11.
//

import Alamofire

class APIEngine {
    
    init() {
        AF.sessionConfiguration.timeoutIntervalForRequest = 10
        AF.sessionConfiguration.timeoutIntervalForResource = 10
    }
}

extension APIEngine {
    
    func requestAsyncDecodable<T: Decodable>(endPoint: EndPoint) async throws -> T {
        
        let urlString = endPoint.baseURL + endPoint.endPoint
        NetworkLogger.log(method: endPoint.method, urlString: urlString, headers: endPoint.headers?.dictionary, parameters: endPoint.parameters)
        
        return try await withUnsafeThrowingContinuation { continuation in
            AF.request(urlString,
                       method: endPoint.method,
                       parameters: endPoint.parameters,
                       encoding: endPoint.encoding,
                       headers: endPoint.headers).validate().responseDecodable(of: T.self) { response in
                
                switch response.result {
                case .success(let decodable):
                    continuation.resume(returning: decodable)
                case .failure(let error):
                    Logger.log(error)
                    continuation.resume(throwing: NetworkError.failure(statusCode: "\(response.response?.statusCode ?? -1)", message: error.localizedDescription))
                }
            }
        }
    }
}

extension APIEngine {
    
    func requestAsync(endPoint: EndPoint) async throws {
        
        let urlString = endPoint.baseURL + endPoint.endPoint
        NetworkLogger.log(method: endPoint.method, urlString: urlString, headers: endPoint.headers?.dictionary, parameters: endPoint.parameters)
        
        return try await withUnsafeThrowingContinuation { continuation in
            AF.request(urlString,
                       method: endPoint.method,
                       parameters: endPoint.parameters,
                       encoding: endPoint.encoding,
                       headers: endPoint.headers).response { (response) in
                
                if let statusCode = response.response?.statusCode {
                    switch statusCode {
                    case 200...299:
                        continuation.resume(returning: ())
                    default:
                        continuation.resume(throwing: NetworkError.failure(statusCode: "\(statusCode)", message: response.error?.localizedDescription ?? ""))
                    }
                } else {
                    continuation.resume(throwing: NetworkError.unstableInternet)
                }
            }
        }
    }
}
