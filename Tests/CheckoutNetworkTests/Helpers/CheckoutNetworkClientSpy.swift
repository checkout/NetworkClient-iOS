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

  var expectedResponseBody: FakeObject?
  var expectedError: Error?

  override func runRequest<T>(with configuration: RequestConfiguration, completionHandler: @escaping CheckoutNetworkClient.CompletionHandler<T>) where T : Decodable {
    runRequestCallCount += 1
    self.configuration = configuration

    if let result = expectedResponseBody {
      completionHandler(.success(result as! T))
    } else if let error = expectedError {
      completionHandler(.failure(error))
    }
  }

  override func runRequest(with configuration: RequestConfiguration, completionHandler: @escaping CheckoutNetworkClient.NoDataResponseCompletionHandler) {
    runRequestCallCount += 1
    self.configuration = configuration

    guard let error = expectedError else {
      completionHandler(nil)
      return
    }

    completionHandler(error)
  }
}
