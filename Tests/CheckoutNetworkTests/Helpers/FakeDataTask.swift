//
//  FakeDataTask.swift
//  
//
//  Created by Alex Ioja-Yang on 21/06/2022.
//

import Foundation

final class FakeDataTask: URLSessionDataTask {
    
    var wasStarted = false
    
    override func resume() {
        wasStarted = true
    }
    
}
