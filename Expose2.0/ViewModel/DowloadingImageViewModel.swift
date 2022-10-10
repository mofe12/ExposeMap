//
//  DowloadingImageViewModel.swift
//  Expose
//
//  Created by Eyimofe Oladipo on 10/8/22.
//

import Foundation
import SwiftUI
import Combine

class DownloadingImageViewModel: ObservableObject{
    
    let manager = YelpPhotosCacheService.instance
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    var cancellable = Set<AnyCancellable>()
    
    
    let urlString: String
    
    init(urlString: String){
        self.urlString = urlString
        getImageFromCache()
    }
    
    func getImageFromCache(){
        if let savedImage = manager.get(key: urlString){
            image = savedImage
            print("Getting saved Images")
        }else {
             downloadImage()
            print("Downloading Image")
        }
        
    }
    
    func downloadImage(){
        isLoading = true
        guard let url = URL(string: urlString) else {
            isLoading = false
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map{UIImage(data: $0.data)}
            .receive(on: DispatchQueue.main)
            .sink { [weak self ](_) in
                self?.isLoading = false
            } receiveValue: { [weak self] (returnedImage) in
                guard let self = self,
                      let newImage = returnedImage else {return}
                self.image = newImage
                self.manager.add(key: self.urlString, value: newImage)
            }
            .store(in: &cancellable)

    }
}
