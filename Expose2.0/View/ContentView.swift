//
//  ContentView.swift
//  Expose2.0
//
//  Created by Eyimofe Oladipo on 5/15/22.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("onBoarding") var onBoarding = 0
    
    @AppStorage("InterestList") var appStrInterestList = 0
    
    @EnvironmentObject var viewModel : MapUIViewModel
    @Binding var changeScreens: changeScreen
    
    var body: some View {
        
        
        if onBoarding == 0{
            NewOnboardingScreen().environmentObject(viewModel)
        }else if onBoarding == 1{
            PhotoSelectedView(changeScreens: $changeScreens)
        }else if onBoarding == 2{
            HomeView(changeScreens: $changeScreens).environmentObject(viewModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(changeScreens: .constant(changeScreen.contentView)).environmentObject(MapUIViewModel())
    }
}

