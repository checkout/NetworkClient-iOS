//
//  CheckoutNetworkError.swift
//
//
//  Created by Alex Ioja-Yang on 20/06/2022.
//

import Foundation

public enum CheckoutNetworkError: LocalizedError, Equatable {

  /// Review the url you provided
  case invalidURL

  /// When a response could not be bound to an instance of HTTPURLResponse
  case invalidURLResponse

  /// Network response was not in the 200 range
  case unexpectedHTTPResponse(code: Int)

  /// Network call and completion appear valid but no data was returned making the parsing impossible. Use runRequest method with NoDataResponseCompletionHandler if no data is expected (HTTP 204 is a success case with no content being returned)
  case noDataResponseReceived

  /// Network response returned with HTTP Code 422
  case unprocessableContent(reason: ErrorReason)

  ///  Connectivity errors mapped from URLSession.dataTask()'s error
  ///
  ///  Only the following are mapped into this error case:
  ///  NSURLErrorNotConnectedToInternet
  ///  NSURLErrorTimedOut
  ///  NSURLErrorNetworkConnectionLost
  ///  NSURLErrorInternationalRoamingOff
  ///  NSURLErrorCannotConnectToHost
  ///  NSURLErrorServerCertificateUntrusted
  case connectivity

  /// All the other errors that can be received from URLSession.
  /// Use the underlying error if you need more granular error handling.
  /// Underlying errors here are in NSURLErrorDomain.
  case other(underlyingError: NSError)

  public var errorDescription: String? {
    switch self {
    case .invalidURL:
      return "Could not instantiate a URL with the provided String value"

    case .invalidURLResponse:
      return "Could not instantiate an HTTPURLResponse with the received response value"

    case .unexpectedHTTPResponse(let code):
      return "Received an unexpected HTTP response: \(code)"

    case .noDataResponseReceived:
      return "No data is received in the response body. Use the method with NoDataResponseCompletionHandler if no data was expected"

    case .unprocessableContent(let reason):
      return "HTTP response 422 is received with: \(reason)"

    case .connectivity:
      return "There is a problem with the internet connection"

    case .other(let error):
      return "An unhandled error is produced: \(error)"
    }
  }
}
