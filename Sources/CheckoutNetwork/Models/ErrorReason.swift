//
//  ErrorReason.swift
//
//
//  Created by Okhan Okbay on 18/01/2024.
//

import Foundation

public struct ErrorReason: Decodable, Equatable {
  public let requestID: String
  public let errorType: String
  public let errorCodes: [String]

  enum CodingKeys: String, CodingKey {
    case requestID = "request_id"
    case errorType = "error_type"
    case errorCodes = "error_codes"
  }
}
