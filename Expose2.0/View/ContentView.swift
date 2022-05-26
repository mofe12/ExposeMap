//
//  ContentView.swift
//  Expose2.0
//
//  Created by Eyimofe Oladipo on 5/15/22.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("onBoarding") var onBoarding = 0
    @EnvironmentObject var viewModel : MapUIViewModel
    @Binding var changeScreens: changeScreen
    
    var body: some View {
        if onBoarding == 0{
            OnBoardingView()
        }else if onBoarding == 1{
            ResultsView(changeScreens: $changeScreens).environmentObject(viewModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(changeScreens: .constant(changeScreen.contentView)).environmentObject(MapUIViewModel())
    }
}
