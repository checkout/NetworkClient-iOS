//
//  FakeObject.swift
//  
//
//  Created by Alex Ioja-Yang on 21/06/2022.
//

import Foundation

/// Enable a generic Decodable parameter to be offered in unit tests
struct FakeObject: Codable, Equatable {
    let id: String
}
