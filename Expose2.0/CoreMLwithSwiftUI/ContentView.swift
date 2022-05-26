//
//  ContentView.swift
//  CoreMLwithSwiftUI
//
//

import SwiftUI
import CoreML

struct ContentView: View {

    let model = MobileNetV2()
    @State private var classificationLabel: String = ""
    
    let photos = ["lemon","strawberry", "electric-guitar"]
    @State private var currentIndex: Int = 0
    
    @State private var resultArray: [String] = []
    
    var body: some View {
        VStack {
            Image(photos[currentIndex])
                .resizable()
                .frame(width: 200, height: 200)
            
            // The button we will use to classify the image using our model
            Button("Classify") {
                // Add more code here
                resultArray = []
                for photo in photos {
                    classifyImage(currentImageName: photo)
                }
                
            }
            .foregroundColor(Color.white)
            .background(Color.green)

            // The Text View that we will use to display the results of the classification
            ForEach(resultArray, id: \.self){ result in
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
        
        let output = try? model.prediction(image: buffer)
        
        if let output = output {
            let results = output.classLabelProbs.sorted { $0.1 > $1.1 }
//            let result = results.map { (key, value) in
//                return "\(key) = \(String(format: "%.2f", value * 100))%"
//            }.joined(separator: "\n")
            let result = results.first
            self.classificationLabel = result?.key ?? "No result"
            resultArray.append(self.classificationLabel)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 12")
    }
}
