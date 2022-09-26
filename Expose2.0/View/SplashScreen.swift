//
//  SplashScreen.swift
//  Expose
//
//  Created by Eyimofe Oladipo on 9/25/22.
//

import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    @State private var endSplash = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    @ObservedObject var mapData: MapUIViewModel
    @AppStorage("onBoarding") var onBoarding = 0
    var body: some View {
        ZStack{
            if endSplash{
                if onBoarding == 0{
                    NewOnboardingScreen()
                }else if onBoarding == 1 {
                    ProtoPhotoSelectorView()
                }else if onBoarding == 2{

                    ProtoHomeView()
                }
            }
            
            ZStack{
                Image("exposepng")
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: isActive ? .fill : .fit)
                    .frame(width: isActive ? nil: 200, height: isActive ? nil : 200)
                
                    .scaleEffect(isActive ? 3: 1)
                
                    .frame(width: UIScreen.main.bounds.width)
            }
            .ignoresSafeArea()
            .onAppear {
                animateSplash()
            }
            .opacity(endSplash ? 0: 1)
        }
        .environmentObject(mapData)
        
    } // MARK: BODY VIEW
    func animateSplash(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25){
            withAnimation(.easeOut(duration: 0.45)){
                isActive.toggle()
            }
            withAnimation(.easeOut(duration: 0.35)){
                endSplash.toggle()
            }
        }
    }
    
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen(mapData: MapUIViewModel())
            .environmentObject(MapUIViewModel())
    }
}
