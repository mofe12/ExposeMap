//
//  ResultsView.swift
//  Expose2.0
//
//  Created by Eyimofe Oladipo on 5/26/22.
//

import SwiftUI

struct ResultsView: View {
    @EnvironmentObject var viewModel : MapUIViewModel
    // For changing screen from the expose button
    @Binding var changeScreens: changeScreen
    var body: some View {
        ZStack {
            Image("MapBack")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .blur(radius: 15)
            VStack {

                VStack(spacing: 78) {
                    Text("YOUR RESULTS SHOW THAT YOU ARE INTERESTED IN ALOT")
                    Text("HERE ARE SOME OF THOSE THINGS:")
                    
                    ScrollView() {
                        ForEach(viewModel.MLPhotoResults, id: \.self){ result in
                            Text(result).textCase(.uppercase)
                                .padding()
                                
                        }
                    }.fixedSize()
                    
                    
                }
                .font(.title2)
                .padding()
            .multilineTextAlignment(.center)
                VStack {
                        Text("GET EXPOSED")
                            .font(.title2)
                            .padding()
                            .background(Color("Turquoise"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                }.onTapGesture {
                    changeScreens = .homeView
                }
                
            }

        }.onAppear {
            viewModel.MLPhotoResults = []
            for photo in viewModel.photosToBeScanned {
                classifyImage(currentImageName: photo)
            }
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

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView(changeScreens: .constant(changeScreen.contentView))
            .environmentObject(MapUIViewModel())
            .preferredColorScheme(.dark)
    }
}
