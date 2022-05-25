//
//  OnBoardingView.swift
//  Expose2.0
//
//  Created by Eyimofe Oladipo on 5/20/22.
//

import SwiftUI

struct OnBoardingView: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("onBoarding") var onBoarding: Int?
    var body: some View {
        
        ZStack {
            Image("MapBack")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .blur(radius: 15)
            VStack(spacing:30) {
                Text("WE CARE ABOUT YOUR PRIVACY ❤️")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.red)
                
                VStack {
                    HStack {
                        Text("Expose")
                        Text("DOES NOT")
                            .fontWeight(.semibold)
                            .foregroundColor(.red)
                        Text("keep or")
                    }.font(.title2)
                
                Text("share any of your photos or information with any third party nor do we store it!")
                        .font(.title2)
                }
                Text("We only use your photos to curate your interest and ultimately give you options for places to get exposed to around you! That’s it!")
                    .font(.title2)
                Text("You pick the photos we use and we make suggestions based on those pictures for you to get Exposed to with the hope that you gain more clarity about the culture and community around you.")
                    .font(.title2)
                Text("Welcome to Exposé!")
                    .font(.title2)
                Spacer()
                
                    Button {
                        onBoarding = 1
                    } label: {
                        Text("Continue")
                            .padding()
                            .padding(.horizontal, 40)
                            .background(Color("Turquoise"))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }.foregroundColor( colorScheme == .light ? Color(.black) : Color(.white)
                        
                        )

                

            }
            .padding()
        .multilineTextAlignment(.center)
        }
    }
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView()
            .preferredColorScheme(.dark)
            
    }
}
