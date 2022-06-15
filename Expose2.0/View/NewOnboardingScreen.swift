//
//  NewOnboardingScreen.swift
//  Expose
//
//  Created by Eyimofe Oladipo on 6/13/22.
//

import SwiftUI

struct NewOnboardingScreen: View {
    @EnvironmentObject var viewModel : MapUIViewModel
    
    @AppStorage("onBoarding") var onBoarding =  0
    @State private var currentStop = 0
    @State private var toggleGetExposedButton = false
    var body: some View {
        ZStack {
            Color("Turquoise")
                .ignoresSafeArea()
            VStack{
                HStack{
                    Spacer()
                    Text("Skip")
                        .foregroundColor(.white)
                        .onTapGesture {
                            currentStop = 2
                        }
                    
                }
                .padding(16)
                Spacer()
            }
            VStack {
                TabView(selection: $currentStop) {
                    ForEach(0..<3) { steps in
                        VStack() {
                            VStack {
                                Image(systemName: viewModel.OnBoardingStepArray[steps].Image)
                                    .resizable()
                                    .frame(width: 150, height: 150)
                                    .foregroundColor(.red)
                                    .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 15)
                                
                            }
                            Text(viewModel.OnBoardingStepArray[steps].Text)
                                .multilineTextAlignment(.center)
                                .font(.title2)
                                .padding(.horizontal,32)
                                .padding(.top,16)
                                .foregroundColor(.white)
                        }
                        //.tag(steps)
                    }
                    
                    
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                
            }
            VStack{
                Spacer()
                if currentStop == 2{
                    Button {
                        onBoarding = 1
                    } label: {
                        continueButton()
                    }
                    .foregroundColor(.primary)
                }
            }
        }
    }
}

struct NewOnboardingScreen_Previews: PreviewProvider {
    static var previews: some View {
        NewOnboardingScreen().environmentObject(MapUIViewModel())
    }
}


struct continueButton: View{
    var body: some View {
        
        VStack {
            Text("GET STARTED")
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(.white)
                .cornerRadius(16)
                .padding(.horizontal, 16)
        }
        
    }
}
