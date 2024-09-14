//
//  CheckoutNetworkClient+AsyncWrappers.swift
//
//
//  Created by Okhan Okbay on 20/02/2024.
//

import Foundation

public extension CheckoutNetworkClient {

  func runRequest<T: Decodable>(with configuration: RequestConfiguration) async throws -> T {
    return try await withCheckedThrowingContinuation { continuation in
      runRequest(with: configuration) { (result: Result<T, CheckoutNetworkError>) in
        switch result {
        case .success(let response):
          continuation.resume(returning: response)
        case .failure(let error):
          continuation.resume(throwing: error)
        }
      }
    }
  }

  func runRequest(with configuration: RequestConfiguration) async throws {
    return try await withCheckedThrowingContinuation { continuation in
      runRequest(with: configuration) { (error: CheckoutNetworkError?) in

        guard let error = error else {
          continuation.resume(returning: Void())
          return
        }

        continuation.resume(throwing: error)
      }
    }
  }
}
