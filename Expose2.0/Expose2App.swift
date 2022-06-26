//
//  Expose2_0App.swift
//  Expose2.0
//
//  Created by Eyimofe Oladipo on 5/15/22.
//

import SwiftUI

@main
struct Expose2App: App {
    @StateObject var mapData = MapUIViewModel()
    @State var changeScreens : changeScreen = .contentView
    
    var body: some Scene {
        WindowGroup {

            if changeScreens == changeScreen.contentView{
                ContentView(changeScreens: $changeScreens).environmentObject(mapData)
            }else if changeScreens == changeScreen.resultView{
                ResultsView(changeScreens: $changeScreens).environmentObject(mapData)
            }else if changeScreens == changeScreen.homeView{
                HomeView(changeScreens: $changeScreens).environmentObject(mapData)
            }else if changeScreens == changeScreen.photoSelectedView{
                PhotoSelectedView(changeScreens: $changeScreens).environmentObject(mapData)
            }
            
           // NewOnboardingScreen()
            
        }
    }
}


enum changeScreen{
    case contentView
    case homeView
    case resultView
    case photoSelectedView
}

