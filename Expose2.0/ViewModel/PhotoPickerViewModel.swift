//
//  PhotoPickerViewModel.swift
//  Expose
//
//  Created by Eyimofe Oladipo on 7/29/22.
//

import Foundation
import PhotosUI


class PhotoPickerViewModel : ObservableObject{
    
    @Published var newPhotosToBeScanned: [UIImage] = []
    @Published var selectedPhotoToShow: [UIImage] = []
    @Published var photoToScanCheck: [UIImage] = []
    
    @Published var isShowingImagePicker = false

    let classifier = ImageClassificationService.instance
    
    // Handle result
    func handleResults(_ results: [PHPickerResult]) {
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] imageObject, error in
                guard let image = imageObject as? UIImage else { return }
                guard let data = image.jpegData(compressionQuality: 0.0), let compressedImage = UIImage(data: data) else{return}
                DispatchQueue.main.async { [weak self] in
                    self?.newPhotosToBeScanned.append(compressedImage)
                    self?.selectedPhotoToShow.append(compressedImage)
                }
            }
        }
    }
    
    func classifyAllImages(_ images: [UIImage]) -> [String]?{
        var results: [String] = []
        for image in images {
            if let result = classifier.classifyImage(currentImageName: image){
                results.append(result)
            }
        }
        return results
    }

}
