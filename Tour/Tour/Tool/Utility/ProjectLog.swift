//
//  ProjectLog.swift
//  Tour
//
//  Narendra Pandey on 04/01/21.
//  Copyright © 2021 Narendra Pandey. All rights reserved.
//

import Foundation

public func plog<T>(_ object: @autoclosure () -> T,
                    _ file: String = #file,
                    _ function: String = #function,
                    _ line: Int = #line) {
    #if DEBUG
    let value = object()
    let fileURL = URL(fileURLWithPath: file)
    let checkThread  = Thread.isMainThread ? "UI" : "BG"
    print("**************************************************")
    print("<\(checkThread)> \(fileURL) \(function)[\(line)]: \n" + String(reflecting: value))
    print("**************************************************")
    #endif
}
