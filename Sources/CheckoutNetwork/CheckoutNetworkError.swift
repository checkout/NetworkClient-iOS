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
 
    /// Network call and completion appear valid but no data was returned making the parsing impossible. Use different call if no data is expected
    case noDataResponseReceived
}
