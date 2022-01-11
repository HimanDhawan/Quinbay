//
//  NetworkHandler.swift
//  Quinbay
//
//  Created by Himan Dhawan on 10/01/22.
//

import Foundation

protocol NetworkHandlerProtocol : AnyObject {
    var request : URLRequest {get set}
    var urlSession : URLSession {get set}
    var dataTask : URLSessionDataTask? {get set}
    func cancelOperation()
    func getData(completionHandler : @escaping NetworkCompletionHandler)
}

typealias NetworkCompletionHandler = (Data?, URLResponse?, Error?) -> Void

class NetworkHandler : NetworkHandlerProtocol {
    
    /// Dependency Injection
    var request : URLRequest
    
    ///
    var urlSession : URLSession = URLSession.shared
    var dataTask : URLSessionDataTask?
    
    init(request : URLRequest) {
        self.request = request
    }
    
}

// MARK: - Provide data with given URL Request
extension NetworkHandler {
    func getData(completionHandler : @escaping NetworkCompletionHandler) {
        dataTask = urlSession.dataTask(with: self.request, completionHandler: completionHandler)
        self.resume()
    }
}

// MARK: - Cancel Operation
extension NetworkHandler {
    func cancelOperation() {
        dataTask?.cancel()
    }
}

// MARK: - Cancel previous search operation
extension NetworkHandler {

    func resume() {
        self.urlSession.getAllTasks { (alltasks) in
            let isUpcomingRequestAMerchantListRequest = self.dataTask?.currentRequest?.url?.absoluteString.contains("/backend/search/products")
            if let isComingMerchantRequest = isUpcomingRequestAMerchantListRequest , isComingMerchantRequest == true {
                self.cancelAllThePreviousSearchTask(alltasks: alltasks)
            }
            self.dataTask?.resume()
            
        }
    }
    
    func cancelAllThePreviousSearchTask(alltasks : [URLSessionTask]) {
        var doesContainMerchantRequest : Bool?
        for task in alltasks {
            doesContainMerchantRequest = task.currentRequest?.url?.absoluteString.contains("/backend/search/products")
            if let isPresent = doesContainMerchantRequest , isPresent == true {
                task.cancel()
            }
        }
    }
}
