//
//  Expose2_0App.swift
//  Expose2.0
//
//  Created by Eyimofe Oladipo on 5/15/22.
//d

import SwiftUI

@main
struct Expose2App: App {
    @StateObject var mapData = MapUIViewModel()
    @AppStorage("onBoarding") var onBoarding = 0
    
    @State var changeScreens : changeScreen = .contentView
    
    var body: some Scene {
        WindowGroup {
            SplashScreen(mapData: mapData)
        }
    }
}


enum changeScreen{
    case contentView
    case homeView
    case resultView
    case photoSelectedView
}

