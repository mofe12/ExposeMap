//
//  DataProvider.swift
//  Expose
//
//  Created by Eyimofe Oladipo on 6/16/22.
//

import Foundation


class DataProvider: ObservableObject{
    
    static let shared = DataProvider()
    private let dataSourceURL: URL
    @Published var allInterest = Interest(Interests: [], photos: [])
    
    private func getInterest() -> Interest{
        do{
            let decoder = PropertyListDecoder()
            let data = try Data(contentsOf: dataSourceURL)
            let decodedInterest = try! decoder.decode(Interest.self, from: data)
            return decodedInterest
        }catch{
            return Interest(Interests: [], photos: [])
        }
    }
    
    init(){
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let interestPath = documentsPath.appendingPathComponent("interest").appendingPathExtension("json")
        dataSourceURL = interestPath
        
        _allInterest = Published(wrappedValue: getInterest())
    }
    
    private func saveInterest(){
        do {
                let encoder = PropertyListEncoder()
                let data = try encoder.encode(allInterest)
                try data.write(to: dataSourceURL)
            } catch {

            }
    }
    
    func create(interest: Interest){
        allInterest.Interests.insert(contentsOf: interest.Interests, at: 0)
        allInterest.photos.insert(contentsOf: interest.photos, at: 0)
        saveInterest()
    }
    
    func get() -> Interest{
        return getInterest()
    }
}
