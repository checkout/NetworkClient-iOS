//
//  CheckoutNetworkClientSpy.swift
//  
//
//  Created by Okhan Okbay on 19/01/2024.
//

@testable import CheckoutNetwork

class CheckoutNetworkClientSpy: CheckoutNetworkClient {
  private(set) var runRequestCallCount: Int = 0
  private(set) var configuration: RequestConfiguration!

  var expectedResult: FakeObject?
  var expectedError: Error?

  override func runRequest<T>(with configuration: RequestConfiguration, completionHandler: @escaping CheckoutNetworkClient.CompletionHandler<T>) where T : Decodable {
    runRequestCallCount += 1
    self.configuration = configuration

    if let result = expectedResult {
      completionHandler(.success(result as! T))
    } else if let error = expectedError {
      completionHandler(.failure(error))
    }
  }
}
