//
//  ContentView.swift
//  CoreMLwithSwiftUI
//
//

import SwiftUI
import CoreML

struct MLContentView: View {
    
    @EnvironmentObject var viewModel : MapUIViewModel
    var body: some View {
        VStack {
            Image(viewModel.photosToBeScanned[0])
                .resizable()
                .frame(width: 200, height: 200)
            
            // The button we will use to classify the image using our model
            Button("Classify") {
                // Add more code here
                viewModel.MLPhotoResults = []
                for photo in viewModel.photosToBeScanned {
                    classifyImage(currentImageName: photo)
                }
                
            }
            .foregroundColor(Color.white)
            .background(Color.green)

            // The Text View that we will use to display the results of the classification
            ForEach(viewModel.MLPhotoResults, id: \.self){ result in
                Text(result)
                    .padding()
                    .font(.body)
            }
            
            Spacer()
        }
    }
    
    private func classifyImage(currentImageName: String) {
        //let currentImageName = photos[currentIndex]
        
        guard let image = UIImage(named: currentImageName),
              let resizedImage = image.resizeImageTo(size:CGSize(width: 224, height: 224)),
              let buffer = resizedImage.convertToBuffer() else {
              return
        }
        
        let output = try? viewModel.model.prediction(image: buffer)
        
        if let output = output {
            let results = output.classLabelProbs.sorted { $0.1 > $1.1 }
            //let result = results.map { (key, value) in
            //    return "\(key) = \(String(format: "%.2f", value * 100))%"
            //}.joined(separator: "\n")
            let result = results.first
            viewModel.MLPhotoResults.append(result?.key ?? "No result")
        }
    }
    
}

struct MLContentView_Previews: PreviewProvider {
    static var previews: some View {
        MLContentView().environmentObject(MapUIViewModel())
            //.previewDevice("iPhone 12")
    }
}
