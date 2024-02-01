//
//  CheckoutNetworkError.swift
//  
//
//  Created by Alex Ioja-Yang on 20/06/2022.
//

import Foundation

public enum CheckoutNetworkError: Error, Equatable {
    
    /// Review the url you provided
    case invalidURL
    
    /// Network response was not in the 200 range
    case unexpectedResponseCode(code: Int)
 
    /// Network call and completion appear valid but no data was returned making the parsing impossible. Use runRequest method with NoDataResponseCompletionHandler if no data is expected (HTTP 204 is a success case with no content being returned)
    case noDataResponseReceived
  
    /// Network response returned with HTTP Code 422
    case invalidData(reason: ErrorReason)
}
