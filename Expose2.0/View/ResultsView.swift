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
                viewModel.classifyImage(currentImageName: photo)
            }
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
