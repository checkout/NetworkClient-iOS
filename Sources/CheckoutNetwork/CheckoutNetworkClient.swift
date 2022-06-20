//
//  CheckoutNetworkClient.swift
//  
//
//  Created by Alex Ioja-Yang on 20/06/2022.
//

import Foundation

public class CheckoutNetworkClient: CheckoutClientInterface {
    
    private var tasks: [String: URLSessionDataTask] = [:]
    private let taskQueue = DispatchQueue(label: "Checkout_Network")
    
    public func runRequest<T: Decodable>(with configuration: RequestConfiguration,
                                              completionHandler: @escaping CompletionHandler<T>) {
        taskQueue.sync {
            var taskID = UUID().uuidString
            while tasks.keys.contains(taskID) {
                taskID = UUID().uuidString
            }
            let request = configuration.request
            let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                self?.tasks.removeValue(forKey: taskID)
                if let error = error {
                    completionHandler(.failure(error))
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                      response.statusCode >= 200,
                      response.statusCode < 300 else {
                    let responseCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                    let returnError = CheckoutNetworkError.unexpectedResponseCode(code: responseCode)
                    completionHandler(.failure(returnError))
                    return
                }

                guard let data = data else {
                    completionHandler(.failure(CheckoutNetworkError.noDataResponseReceived))
                    return
                }
                do {
                    let dataResponse = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(.success(dataResponse))
                } catch {
                    completionHandler(.failure(error))
                }
            }
            self.tasks[taskID] = task
            task.resume()
        }
    }
    
}