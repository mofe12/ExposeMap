//
//  FileManagerModel.swift
//  Expose
//
//  Created by Eyimofe Oladipo on 6/16/22.
//

import Foundation
import UIKit

//struct Interest: Codable, Identifiable {
//
//    // MARK: - Properties
//    var id = UUID()
//    var Interests: [String]
//    var photos: [String]
//}


struct Interest: Codable, Identifiable {
    
    // MARK: - Properties
    var id = UUID()
    var interests: [String]
    var photos: [Data]
}


struct AppInterest: Codable, Identifiable{
    var id = UUID()
    var interest: String?
    var photos: Data?
}


