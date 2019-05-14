//
//  Log.swift
//  Code
//
//  Created by Spencer Prescott on 5/13/19.
//  Copyright © 2019 Spencer Prescott. All rights reserved.
//

import Foundation

final class Log {
    static func error(_ message: @autoclosure () -> Any,
                      _ file: String = #file,
                      _ function: String = #function,
                      _ line: Int = #line) {
        log("\(message())", levelIdentifier: "❤️", file: file, function: function, line: line)
    }
    
    static func debug(_ message: @autoclosure () -> Any,
                      _ file: String = #file,
                      _ function: String = #function,
                      _ line: Int = #line) {
        log("\(message())", levelIdentifier: "💙", file: file, function: function, line: line)
    }

    static func log(_ message: String,
                    levelIdentifier: String,
                    file: String,
                    function: String,
                    line: Int) {
        print("\(levelIdentifier) \(stripFilePath(file)):\(line) - \(function)\n\(message)")
    }
    
    private static func stripFilePath(_ file: String) -> String {
        let fileParts = file.components(separatedBy: "/")
        if let fileName = fileParts.last, !fileName.isEmpty {
            return fileName
        }
        
        return "File Not Found"
    }
}

