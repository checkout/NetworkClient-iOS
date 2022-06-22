//
//  RequestConfiguration.swift
//  
//
//  Created by Alex Ioja-Yang on 20/06/2022.
//

import Foundation

/// Configuration object for the URLRequest to be created and handled by client
public struct RequestConfiguration {
    
    /// Request created from the consumers configuration
    let request: URLRequest
    
    /// Create request configuration with provided parameters. In case of failure will throw a `CheckoutNetworkError`
    ///
    /// - Parameter path: Should be an enum case that is able to generate URL for request
    /// - Parameter httpMethod: Type of network request
    /// - Parameter queryItems: Dictionary of key-value pairs that will be included in the final URL as query parameters
    /// - Parameter customHeaders: Headers to be added to the request. If key already exists, provided value will override internal value
    /// - Parameter bodyData: Data to be added to request. Will get injected as is, so any custom encryption or logic can be applied before creating it
    /// - Parameter mimeType: Inform server how to process the request by specifying the  MIME Type associated
    public init(path: NetworkPath,
                httpMethod: HTTPMethod = .get,
                queryItems: [String: String] = [:],
                customHeaders: [String: String] = [:],
                bodyData: Data? = nil,
                mimeType: MIMEType = .JSON) throws {
        // Validate URL can be broken down to components for formatting
        guard var components = URLComponents(url: path.url(), resolvingAgainstBaseURL: true) else {
            throw CheckoutNetworkError.invalidURL
        }
        
        // Prevent declaring query items if none will be needed. Result would be urls ending with "?"
        if !queryItems.isEmpty {
            components.queryItems = components.queryItems ?? []
        }
        // Convert provided Query Items Dictionary to URL QueryItems components
        queryItems
            .compactMap { URLQueryItem(name: $0.key, value: $0.value) }
            .forEach { components.queryItems?.append($0) }
        
        // Ensure components generate valid url that can build a request
        guard let finalURL = components.url else {
            throw CheckoutNetworkError.invalidURL
        }
        
        // Create request and add content & headers to request
        var request = URLRequest(url: finalURL)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = bodyData
        if bodyData != nil {
            request.addValue(mimeType.rawValue, forHTTPHeaderField: MIMEType.key)
        }
        customHeaders.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        self.request = request
    }

}
