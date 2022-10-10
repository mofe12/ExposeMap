//
//  YelpAPIService.swift
//  Expose
//
//  Created by Eyimofe Oladipo on 10/6/22.
//

import SwiftUI
import Combine

class YelpAPIService{
    
    static let instance = YelpAPIService()
    
    @Published var yelpResults: YelpMatch?
    {
        didSet{
            guard yelpResults?.businesses?.isEmpty != true else {return}
            if let business = yelpResults?.businesses{
                downloadDetailBusData(withID: business[0].id)
            }
        }
    }
    @Published var yelpBusinessDetail: YelpBusinessDetail?
    
    var cancellables = Set<AnyCancellable>()
//    private var latitude = 42.386540
//    private var longitude = -83.106230
//    private var searchTerm = "pizza"
    private var token = "4nDLZ2fEsI3yw11x6OuIaohesq-46CU0hfVLL_lFaz4r2vbO19Bn718QiY_mWzAZJvptgxstsiLPGiTe8Fmu_P9oLreau9tmEf1gP0BMLT2vMdEMLWjQ1HkX1sOXYnYx"
    
    
    
    
    func downloadSearchData(name: String, address: String, city: String, state: String, isoCountry: String){
        
        guard let url = URL(string: "https://api.yelp.com/v3/businesses/matches?name=\(addAmpersand(in: name))&address1=\(addAmpersand(in:address))&city=\(addAmpersand(in: city))&state=\(state)&country=\(isoCountry)") else {return}
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap(handleOutput)
            .decode(type: YelpMatch.self, decoder: JSONDecoder())
            .sink { (completion) in
                switch completion{
                case .finished:
                    break
                case .failure(let error):
                    print("ERROR DOWNLOADING MATCH DATA: \(error)")
                }
            } receiveValue: { [weak self] (returnedYelpMatch) in
                self?.yelpResults = returnedYelpMatch
            }
            .store(in: &cancellables)

    }
    
    private func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data{
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300
        else{
            print("URL REQUEST WAS NOT SUCCESSFULL")
            throw URLError(.badServerResponse)
        }
        
        return output.data
    }
    
    
    func downloadDetailBusData(withID id: String){
        guard let url = URL(string: "https://api.yelp.com/v3/businesses/\(id)") else {return}
            
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap(handleOutput)
            .decode(type: YelpBusinessDetail.self, decoder: JSONDecoder())
            .sink { (completion) in
                switch completion{
                case .finished:
                    break
                case .failure(let error):
                    print("ERROR DOWNLOADING BUSINESS DETAIL DATA: \(error)")
                }
            } receiveValue: { [weak self] (returnedYelpSearch)in
                self?.yelpBusinessDetail = returnedYelpSearch
            }
            .store(in: &cancellables)
        
                
    }
    func addAmpersand(in word: String) -> String{
        var newWord: String = ""
        
        for char in word{
            if char.description == " "{
                newWord.append("%20")
                continue
            }
            newWord.append(char)
        }
        return newWord
    }
    
}
