//
//  SearchAPIHandler.swift
//  Quinbay
//
//  Created by Himan Dhawan on 10/01/22.
//

import Foundation

typealias SearchAPICompletionHandler = (ProductResponse?, Error?) -> Void

protocol SearchHandlerProtocol {
    var urlComponents : URLComponents {get set}
    var numberOfItemsPerPage : Int {get set}
    var networkHandler : NetworkHandler? {get set}
    func search(text : String, page : Int, numberOfItemsPerPage : Int, completionHandler : @escaping SearchAPICompletionHandler)
}

class SearchAPIHandler : SearchHandlerProtocol {
    
    // Dependency Injection
    var urlComponents : URLComponents
    var numberOfItemsPerPage : Int
    var networkHandler : NetworkHandler?
    
    init(numberOfItemsPerPage : Int = 24) {
        self.numberOfItemsPerPage = numberOfItemsPerPage
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "blibli.com"
        urlComponents.path = "/backend/search/products"
        
        self.urlComponents = urlComponents
    }
    
}

extension SearchAPIHandler {
    
    func search(text : String, page : Int = 0, numberOfItemsPerPage : Int = 24, completionHandler : @escaping SearchAPICompletionHandler) {
        
        let queryParams: [String: String] = [
            "searchTerm": text,
            "start": "\(page)",
            "itemPerPage" : "\(numberOfItemsPerPage)"
        ]
        urlComponents.setQueryItems(with: queryParams)
        
        guard let url = urlComponents.url else {return}
        
        let request = URLRequest.init(url: url)
        
        APINetworkLogger.log(request: request)
        
        networkHandler = NetworkHandler.init(request: request)
        
        networkHandler?.getData { data, response, error in
            
            /// When the task is initiated and we cancel it, the completion handler gives cancelled callback with error code 999.
            /// Return the call without giving it back to user.
            if let error = error as NSError?, error.code == -999 {
                return
            }
            
            if error == nil, let data = data {
                
                do {
                    let data = try JSONDecoder().decode(ProductResponse.self, from: data)
                    completionHandler(data,nil)
                } catch {
                    let jsonResponse = String(decoding: data, as: UTF8.self)
                    
                    print("Faulty JSON - URL: \n" + (response?.url?.absoluteString ?? ""))
                    
                    print("Response: \n" + jsonResponse)
                    
                    print("Deserialize error: \(error)")
                    
                }
                
            } else {
                completionHandler(nil,error)
            }
        }
    }
    
}

extension URLComponents {
    
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
    
}

