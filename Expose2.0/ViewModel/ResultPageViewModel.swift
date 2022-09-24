//
//  ResultPageViewModel.swift
//  Expose
//
//  Created by Eyimofe Oladipo on 9/16/22.
//

import Foundation
import SwiftUI
import CoreData

class ResultPageViewModel: ObservableObject{
    
    let manager = CoreDataService.instance
    let mlService = ImageClassificationService.instance
    
    @Published var appInterest: [AppInterest] = []
    @Published var interestEntities: [InterestEntity] = []
    @Published var homeViewisPresented: Bool = false
    
    
    func getInterest(){
        let request = NSFetchRequest<InterestEntity>(entityName: "InterestEntity")
        
        do{
            interestEntities = try manager.context.fetch(request)
        }catch let error{
            print("COULD NOT GET INTEREST. \(error.localizedDescription)")
        }
    }
    
    func save(){
        self.manager.save()
    }
    
    func addInterest(interests: [AppInterest]){
        
        guard !interests.isEmpty else {return}
        for interest in interests {
            let newEntity = InterestEntity(context: manager.context)
            newEntity.interestID = interest.id
            newEntity.image = interest.photos
            newEntity.interest = interest.interest
            save()
        }
        
        
    }
    
    func getImageInterest(from interests: [AppInterest]?) {
        guard interests != nil else { return }
        var container: [AppInterest] = []
        var scannedInterest: [String] = []
        
        for interest in interests!{
            if let imageData = interest.photos,
               let image = UIImage(data: imageData){
                
                let result = mlService.classifyImage(currentImageName: image)
                
                if !scannedInterest.contains(result  ?? ""){
                    container.append(AppInterest(interest: result, photos: imageData))
                    scannedInterest.append(result ?? "")
                }

                scannedInterest.append(mlService.classifyImage(currentImageName: image) ?? "")
                
            }else{
                print("ERROR UNWRAPPING IMAGE getImageInterest()")
            }
        }
        
        appInterest = refineInterestList(interests: container)
    }
    
    
    
    func checkForDuplicateInterest(interests: [AppInterest]) -> [AppInterest] {
        var container: [AppInterest] = interests
        
        for (index,interest) in interests.enumerated() {
            for i in index+1..<interests.count{
                if interest.interest != interests[i].interest{
                    container.append(interest)
                }
            }
        }
        return container
    }
    
    func refineInterestList(interests: [AppInterest]) -> [AppInterest]{
        guard interests.isEmpty == false else{ return [] }
        var container = interests
        
        var interestString: [String] = []
        
        for interestEntity in interestEntities {
            interestString.append(interestEntity.interest!)
        }
        
        for (index, value) in container.enumerated(){
            if interestString.contains(value.interest ?? " "){
                container.remove(at: index)
            }
        }
        
        return container
    }
}
