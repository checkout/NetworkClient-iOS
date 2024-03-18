//
//  CheckoutNetworkFakeClient.swift
//  
//
//  Created by Alex Ioja-Yang on 20/06/2022.
//

import Foundation
import CheckoutNetwork

final public class CheckoutNetworkFakeClient: CheckoutClientInterface {
    public var calledRequests: [(config: RequestConfiguration, completion: Any)] = []

    public var calledAsyncRequests: [RequestConfiguration] = []
    public var dataToBeReturned: Decodable!
    public var errorToBeThrown: CheckoutNetworkError?

    public func runRequest<T: Decodable>(with configuration: RequestConfiguration,
                                         completionHandler: @escaping CompletionHandler<T>) {
        calledRequests.append((config: configuration, completion: completionHandler))
    }

    public func runRequest(with configuration: RequestConfiguration,
                           completionHandler: @escaping NoDataResponseCompletionHandler) {
        calledRequests.append((configuration, completionHandler))
    }
}

extension CheckoutNetworkFakeClient {
  public func runRequest<T: Decodable>(with configuration: CheckoutNetwork.RequestConfiguration) async throws -> T {
      calledAsyncRequests.append(configuration)
      // swiftlint:disable force_cast
      guard let error = errorToBeThrown else {
        return dataToBeReturned as! T
      }
      throw error
      // swiftlint:enable force_cast
  }

  public func runRequest(with configuration: RequestConfiguration) async throws {
      calledAsyncRequests.append(configuration)
      try await Task.sleep(nanoseconds: 1 * 1_000_000_000) // 1 second
      guard let error = errorToBeThrown else {
        return ()
      }
      throw error
  }
}
