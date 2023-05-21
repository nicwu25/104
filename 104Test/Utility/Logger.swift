//
//  Logger.swift
//  104Test
//
//  Created by Nic Wu on 2023/5/11.
//

import Foundation

class Logger {
    
    static func log<T>(message: T, file: String = #file, method: String = #function) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("[\(fileName): \(method)] \(message)")
        #endif
    }
    
    static func log<T>(_ message: T) {
        #if DEBUG
        print(message)
        #endif
    }
}

