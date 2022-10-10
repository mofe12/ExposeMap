//
//  YelpMatchBusModel.swift
//  Expose
//
//  Created by Eyimofe Oladipo on 10/7/22.
//

import Foundation

// MARK: - Welcome
struct YelpMatch: Codable {
    let businesses: [Business]?
}

// MARK: - Business
struct Business: Codable {
    let id, alias, name: String
    let coordinates: Coordinates
    let location: Location
    let phone, displayPhone: String

    enum CodingKeys: String, CodingKey {
        case id, alias, name, coordinates, location, phone
        case displayPhone = "display_phone"
    }
}


