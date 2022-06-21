//
//  CheckoutNetworkClient.swift
//  
//
//  Created by Alex Ioja-Yang on 20/06/2022.
//

import Foundation

public class CheckoutNetworkClient: CheckoutClientInterface {
    
    var tasks: [String: URLSessionDataTask] = [:]
    let session: Session
    
    private let taskQueue = DispatchQueue(label: "Checkout_Network")
    
    public init() {
        self.session = URLSession.shared
    }
    
    init(session: Session = URLSession.shared) {
        self.session = session
    }
    
    /// Create, customise and run a request with the given configuration, calling the completion handler once completed
    public func runRequest<T: Decodable>(with configuration: RequestConfiguration,
                                         completionHandler: @escaping CompletionHandler<T>) {
        taskQueue.sync {
            let taskID = createUniqueTaskIdentifier()
            let request = configuration.request
            let task = session.dataTask(with: request) { [weak self] data, response, error in
                self?.tasks.removeValue(forKey: taskID)
                guard let self = self else { return }
                if let error = error {
                    completionHandler(.failure(error))
                    return
                }
                if let responseError = self.getErrorFromResponse(response) {
                    completionHandler(.failure(responseError))
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
    
    public func runRequest(with configuration: RequestConfiguration,
                           completionHandler: @escaping NoDataResponseCompletionHandler) {
        taskQueue.sync {
            let taskID = createUniqueTaskIdentifier()
            let request = configuration.request
            let task = session.dataTask(with: request) { [weak self] data, response, error in
                self?.tasks.removeValue(forKey: taskID)
                guard let self = self else { return }
                if let error = error {
                    completionHandler(error)
                    return
                }
                if let responseError = self.getErrorFromResponse(response) {
                    completionHandler(responseError)
                    return
                }
                completionHandler(nil)
            }
            self.tasks[taskID] = task
            task.resume()
        }
    }
    
    private func createUniqueTaskIdentifier() -> String {
        var taskID = UUID().uuidString
        while tasks.keys.contains(taskID) {
            taskID = UUID().uuidString
        }
        return taskID
    }
    
    private func getErrorFromResponse(_ response: URLResponse?) -> Error? {
        guard let response = response as? HTTPURLResponse else {
            return CheckoutNetworkError.unexpectedResponseCode(code: 0)
        }

        guard response.statusCode >= 200,
              response.statusCode < 300 else {
            return CheckoutNetworkError.unexpectedResponseCode(code: response.statusCode)
        }
        return nil
    }
}
