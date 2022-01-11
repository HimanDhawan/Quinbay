//
//  SearchControllerViewModel.swift
//  Quinbay
//
//  Created by Himan Dhawan on 10/01/22.
//

import Foundation

protocol SearchControllerViewModelDelegate : AnyObject {
    func productDataFetched()
}

class SearchControllerViewModel : NSObject {
    
    /// Dependency Injection
    private let searchHandler : SearchHandlerProtocol
    private let numberOfItemsPerPage = 24
    
    /// Delegate
    weak var delegate : SearchControllerViewModelDelegate?
    
    /// Table Cell Data
    var products : [Product] = []
    
    ///
    private var page = 0
    private var isFetchInProgress = false
    
    /// Public
    var currentCount: Int {
      return products.count
    }
    
    // Following solid principle. Here developer can create customer search handlers and provide here.
    init(searchHandler : SearchHandlerProtocol) {
        self.searchHandler = searchHandler
    }
    
}

// MARK: - Search
extension SearchControllerViewModel {
    // Search for text with 0 page
    func search(text : String) {
        page = 0
        self.searchHandler.search(text: text, page: page, numberOfItemsPerPage: numberOfItemsPerPage) { [weak self] productResponse, error in
            
            guard let data = productResponse, let self = self, let product = data.data?.products  else { self?.products = []; self?.delegate?.productDataFetched(); return}
            
            if data.code == 200 {
                self.products = []
                self.products = product
            } else {
                self.products = []
                print("error")
            }
            self.delegate?.productDataFetched()
        }
    }
    
    // Search for next page
    func searchNextPage(text : String) {
        
        guard !isFetchInProgress else {
          return
        }
        
        isFetchInProgress = true
        
        page = page + 1
        self.searchHandler.search(text: text, page: page, numberOfItemsPerPage: numberOfItemsPerPage) { [weak self] productResponse, error in
            
            
            DispatchQueue.main.async {
                
                self?.isFetchInProgress = false
                
                guard let data = productResponse, let self = self, let product = data.data?.products  else {return}
                
                if data.code == 200 {
                    self.products.append(contentsOf: product)
                    
                    self.delegate?.productDataFetched()
                } else {
                    self.products = []
                    print("error")
                    self.delegate?.productDataFetched()
                }
                
                
            }
            
        }
    }
    
}


