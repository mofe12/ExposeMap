//
//  ResultsView.swift
//  Expose2.0
//
//  Created by Eyimofe Oladipo on 5/26/22.
//

import SwiftUI

struct ResultsView: View {
    @EnvironmentObject var viewModel : MapUIViewModel
    
    
    @GestureState private var dragOffset = CGSize.zero
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    // For changing screen from the expose button
    @Binding var changeScreens: changeScreen
    var body: some View {
        ZStack {
            Image("MapBack")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                //.ignoresSafeArea()
                .blur(radius: 15)
            VStack {
                Message()
                Spacer()
                ScrollView(){
                    ForEach(viewModel.MLPhotoResults, id: \.self){ result in
                        Text(result)
                            .font(.title2)
                            .fontWeight(.black).textCase(.uppercase)
                            .padding()
                    }
                }
                GetExposed(changeScreens: $changeScreens)
                    .opacity(100)
                
                Spacer()
                    .frame( height: 50)
                
            }

            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action : {
                self.mode.wrappedValue.dismiss()
            }){
                Text("\(Image(systemName: "chevron.backward"))")
                    .font(.title2)
                    .foregroundColor(Color("Turquoise"))
                    .padding(6)
                    .padding(6.0)

            })
                    .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in

                        if(value.startLocation.x < 20 && value.translation.width > 100) {
                            self.mode.wrappedValue.dismiss()
                        }

                }))
            
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

struct Message: View{
    var body: some View{
        VStack(spacing: 78) {
            Text("YOUR RESULTS SHOW THAT YOU ARE INTERESTED IN ALOT")
                .font(.title2)
                .fontWeight(.black)

            Text("HERE ARE SOME OF THOSE THINGS:")
                .font(.title2)
                .fontWeight(.black)
        }
        .padding()
        .multilineTextAlignment(.center)
        
    }
}

struct GetExposed: View{
    @Binding var changeScreens: changeScreen
    @AppStorage("onBoarding") var onBoarding = 0
    var body: some View{
        VStack {
            Text("GET EXPOSED")
                .font(.title2)
                .fontWeight(.black)
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(Color("Turquoise"))
                .cornerRadius(16)
                .padding(.horizontal, 16)
                
        }
        .onTapGesture {
            changeScreens = .homeView
            onBoarding = 2
            
        }
    }
}


