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
    
    public func runRequest<T: Decodable>(with configuration: RequestConfiguration,
                                         completionHandler: @escaping CompletionHandler<T>) {
        calledRequests.append((config: configuration, completion: completionHandler))
    }
    
    public func runRequest(with configuration: RequestConfiguration,
                           completionHandler: @escaping NoDataResponseCompletionHandler) {
        calledRequests.append((configuration, completionHandler))
    }
    
}
