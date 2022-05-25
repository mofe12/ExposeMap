//
//  ContentView.swift
//  Expose2.0
//
//  Created by Eyimofe Oladipo on 5/15/22.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("onBoarding") var onBoarding = 0
    var body: some View {
        if onBoarding == 0{
            OnBoardingView()
        }else if onBoarding == 1{
            HomeView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
