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
            }else if changeScreens == changeScreen.homeView{
                HomeView().environmentObject(mapData)
            }
            
        }
    }
}


enum changeScreen{
    case contentView
    case homeView
}
