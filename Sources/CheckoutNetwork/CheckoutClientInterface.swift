//
//  CheckoutClientInterface.swift
//  
//
//  Created by Alex Ioja-Yang on 20/06/2022.
//

import Foundation

/// Interface for a network client that can support Checkout networking requirements
public protocol CheckoutClientInterface {
    
    /// Completion handler that will return a result containing a decodable object or an error
    typealias CompletionHandler<T> = ((Result<T, Error>) -> Void)
    
    /// Completion handler that will return errors if it fails or nothing if it completes as expected
    typealias NoDataResponseCompletionHandler = ((Error?) -> Void)
    
    /// Create, customise and run a request with the given configuration, calling the completion handler once completed
    func runRequest<T: Decodable>(with configuration: RequestConfiguration,
                                  completionHandler: @escaping CompletionHandler<T>)
}

