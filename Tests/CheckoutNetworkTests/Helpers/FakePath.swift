//
//  FakePath.swift
//  
//
//  Created by Alex Ioja-Yang on 20/06/2022.
//

import Foundation
import CheckoutNetwork

enum FakePath: NetworkPath {
    
    case testServices
    
    func url() -> URL {
        switch self {
        case .testServices: return URL(string: "https://google-not.now")!
        }
    }
    
}
