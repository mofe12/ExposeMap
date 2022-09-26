//
//  PhotoPickerViewModel.swift
//  Expose
//
//  Created by Eyimofe Oladipo on 7/29/22.
//

import Foundation
import PhotosUI
import Combine
import CoreData
import SwiftUI

class PhotoPickerViewModel : ObservableObject{
    
    
     let COLUMN: [GridItem] = [
        GridItem(.flexible(), spacing: 20, alignment: nil),
        GridItem(.flexible(), spacing: 20, alignment: nil)
    ]
    
    @Published var gottenInterest: [AppInterest] = []
    @Published var navActive: Bool = false
    
    @Published var selectedPhotoToShow: [AppInterest] = []
    @Published var photoToScanCheck: [AppInterest] = []
    var cancellable = Set<AnyCancellable>()
    
    @Published var isShowingImagePicker = false

    let classifier = ImageClassificationService.instance
    let manager = CoreDataService.instance
    
    
    @Published var interestEntities: [InterestEntity] = []
    // Handle result
    func handleResults(_ results: [PHPickerResult]) {
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { imageObject, error in
                guard let image = imageObject as? UIImage else { return }
                guard let data = image.jpegData(compressionQuality: 0.0) else{return}
                DispatchQueue.main.async {
                    self.selectedPhotoToShow.append(AppInterest( interest: nil, photos: data))
                }
            }
        }
    }
    
    func classifyAllImages(_ container: [AppInterest]) -> [AppInterest]{
        var interests: [AppInterest] = container
        for (index,interest) in interests.enumerated() {
            if let photoImage = interest.photos,
               let image = UIImage(data: photoImage),
               let result = classifier.classifyImage(currentImageName: image )
            {
                interests[index].interest = result
            }
        }
        return interests
    }

    
    func getInterest(){
        let request = NSFetchRequest<InterestEntity>(entityName: "InterestEntity")
        var container: [InterestEntity] = []
        DispatchQueue.global(qos: .background).async {
            do{
                 container = try self.manager.context.fetch(request)
            }catch let error{
                print("ERROR FETCHING INTEREST. \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                self.interestEntities = container
            }
        }
       
    }
    
    
    func deleteInterest(interestID: UUID){
        for interestEntity in interestEntities {
            if interestEntity.interestID == interestID{
                manager.context.delete(interestEntity)
                break
            }
        }
        save()
    }
    
    func save(){
        manager.save()
        getInterest()
    }
    
    func deleteInterest(from interestID: UUID){
        for (index,photo) in selectedPhotoToShow.enumerated() {
            if photo.id == interestID{
                selectedPhotoToShow.remove(at: index)
            }
        }
    }
    
    init(){
      getInterest()
    }
    

}
