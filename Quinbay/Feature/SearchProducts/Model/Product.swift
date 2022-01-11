//
//  Product.swift
//  Quinbay
//
//  Created by Himan Dhawan on 10/01/22.
//

import Foundation

struct ProductResponse : Codable {
    let code : Int
    let status : String
    let data : ProductData?
}

struct ProductData : Codable {
    let products : [Product]
}

struct Product : Codable {
    let name : String
    let location : String?
    let price : Price
    let images : [String]
    let review : Review
}

struct Price : Codable {
    let priceDisplay : String
    let offerPriceDisplay : String?
    let strikeThroughPriceDisplay : String?
    let minPrice : Int
    let discount : Int
}

struct Review : Codable {
    let rating : Int
    let count : Int
    
}


