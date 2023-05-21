//
//  NetworkLogger.swift
//  104Test
//
//  Created by Nic Wu on 2023/5/11.
//

import Alamofire

struct NetworkLogger {
    
    static func log(method: HTTPMethod, urlString: String, headers: [String: String]? = nil, parameters: [String: Any]? = nil) {
        
        var json: String {
            
            let invalidJson = "Not a valid JSON"
            
            if let parameters = parameters, let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) {
                return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
            }
            return invalidJson
        }
        
        let logOutput = """

                          ===== URLSession =====
                          \(method)
                          url: \(urlString)
                          headers: \(String(describing: headers))
                          parameters: \(json)
                          ===== END =====

                          """
                          
        Logger.log(logOutput)
    }
}
