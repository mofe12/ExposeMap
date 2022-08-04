//
//  ImageClassificationService.swift
//  Expose
//
//  Created by Eyimofe Oladipo on 7/29/22.
//

import Foundation
import PhotosUI

class ImageClassificationService{
    static let instance = ImageClassificationService() // Singleton
    
    // Instiating ML model
    let model = MobileNetV2()

    
    private init(){}
    
    func classifyImage(currentImageName: UIImage) -> String? {
        let image = currentImageName
        var stringOfResult: String
        guard let resizedImage = image.resizeImageTo(size:CGSize(width: 224, height: 224)),
              let buffer = resizedImage.convertToBuffer() else {
            return nil
        }
        
        let output = try? model.prediction(image: buffer)
        
        if let output = output {
            let results = output.classLabelProbs.sorted { $0.1 > $1.1 }
            //let result = results.map { (key, value) in
            //    return "\(key) = \(String(format: "%.2f", value * 100))%"
            //}.joined(separator: "\n")
            let result = results.first
            stringOfResult = result?.key ?? "No result"
            if let index = (stringOfResult.range(of: ",")?.lowerBound)
            {
                stringOfResult = String(stringOfResult.prefix(upTo: index))
            }
            
            return stringOfResult
            
            // Making sure interest does not repeat itself
//            if !MLPhotoResults.contains(stringOfResult){
//                NewMLPhotoResults.append(stringOfResult)
//                MLPhotoResults.append(stringOfResult)
//
//            // Changing UIImage into String
//                changeUIImageToString(currentImageName)
//            }
        }
        return nil

    }
}
