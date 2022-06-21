//
//  FakeSession.swift
//  
//
//  Created by Alex Ioja-Yang on 21/06/2022.
//

import Foundation
@testable import CheckoutNetwork

final class FakeSession: Session {
    
    public var calledDataTasks: [(request: URLRequest, completion: ((Data?, URLResponse?, Error?) -> Void))] = []
    public var calledDataTasksReturn = FakeDataTask()
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        calledDataTasks.append((request, completionHandler))
        return calledDataTasksReturn
    }
}
