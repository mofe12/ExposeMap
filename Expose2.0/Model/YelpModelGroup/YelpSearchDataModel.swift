//
//  YelpDataModel.swift
//  Expose
//
//  Created by Eyimofe Oladipo on 10/6/22.
//

import Foundation

//struct YelpSearch: Codable {
//    let businesses: [Business]?
//}

// MARK: - Business
//struct Business: Identifiable, Codable {
//    let id, alias, name: String
//    let imageURL: String
//    let isClosed: Bool
//    let url: String
//    let reviewCount: Int
//    let categories: [Category]
//    let rating: Double
//    let coordinates: Coordinates
//    let transactions: [String]
//    let location: Location
//    let phone, displayPhone: String
//    let distance: Double
//
//    enum CodingKeys: String, CodingKey {
//        case id, alias, name
//        case imageURL = "image_url"
//        case isClosed = "is_closed"
//        case url
//        case reviewCount = "review_count"
//        case categories, rating, coordinates, transactions, location, phone
//        case displayPhone = "display_phone"
//        case distance
//    }
//}

// MARK: - Category
struct Category: Codable {
    let alias, title: String
}

// MARK: - Coordinates
struct Coordinates: Codable {
    let latitude, longitude: Double
}

// MARK: - Location
struct Location: Codable {
    let address1, address2, address3: String?
    let city, zipCode, country, state: String
    let displayAddress: [String]

    enum CodingKeys: String, CodingKey {
        case address1, address2, address3, city
        case zipCode = "zip_code"
        case country, state
        case displayAddress = "display_address"
    }
}
