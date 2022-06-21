//
//  Session.swift
//  
//
//  Created by Alex Ioja-Yang on 21/06/2022.
//

import Foundation

/// Protocol describing an object that is able to create tasks that can be run
internal protocol Session: AnyObject {
    
    /// Create a data task with the given request and completionHandler
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: Session { }
