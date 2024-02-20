//
//  CheckoutNetworkClient+ErrorHandling.swift
//
//
//  Created by Okhan Okbay on 20/02/2024.
//

import Foundation

extension CheckoutNetworkClient {
  func getErrorFromResponse(_ response: URLResponse?, data: Data?) -> Error? {
    guard let response = response as? HTTPURLResponse else {
      return CheckoutNetworkError.invalidURLResponse
    }

    guard response.statusCode != 422 else {
      do {
        let errorReason = try JSONDecoder().decode(ErrorReason.self, from: data ?? Data())
        return CheckoutNetworkError.unprocessableContent(reason: errorReason)
      } catch {
        return CheckoutNetworkError.noDataResponseReceived
      }
    }

    guard (200..<300).contains(response.statusCode) else {
      return CheckoutNetworkError.unexpectedHTTPResponse(code: response.statusCode)
    }
    return nil
  }

  func convertDataTaskErrorsToCheckoutNetworkError(error: Error) -> CheckoutNetworkError {
    let error = error as NSError

    switch error.code {
    case NSURLErrorNotConnectedToInternet,
      NSURLErrorTimedOut,
      NSURLErrorNetworkConnectionLost,
      NSURLErrorInternationalRoamingOff,
      NSURLErrorCannotConnectToHost,
      NSURLErrorServerCertificateUntrusted:

      return .connectivity

    default:
      return .other(underlyingError: error)
    }
  }
}
