//
//  NetworkError.swift
//  104Test
//
//  Created by Nic Wu on 2023/5/11.
//

import Foundation

enum NetworkError: Error {
    case failure(statusCode: String, message: String)
    case unableToDecode(errorString: String)
    case unstableInternet
    case noData
    case unknown
    
    func getErrorMessage() -> String {
        switch self {
        case .failure(let statusCode, let message):
            return "\(statusCode): \(message)"
        case .unableToDecode:
            return "Could not decode the response"
        case .unstableInternet:
            return "There is an error with the network connection, please try again later"
        case .noData:
            return "no data"
        case .unknown:
            return "unknown error"
        }
    }
}

extension Error {
    func asNetworkError() -> NetworkError {
        self as? NetworkError ?? .unknown
    }

    func getNetworkErrorMessage() -> String {
        asNetworkError().getErrorMessage()
    }
}
