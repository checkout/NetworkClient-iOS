//
//  NetworkPath.swift
//  
//
//  Created by Alex Ioja-Yang on 20/06/2022.
//

import Foundation

/// Shared interface for generating an url from your structure grouping your endpoints
public protocol NetworkPath {
  
  /// URL to be used for creation of a network request
  var url: URL? { get }
}
