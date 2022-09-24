//
//  ProtoHomeView.swift
//  Expose
//
//  Created by Eyimofe Oladipo on 9/19/22.
//

import SwiftUI

struct ProtoHomeView: View {
    @EnvironmentObject var mapData : MapUIViewModel
    var body: some View {
        NavigationView {
            ZStack(){
                MapUIView()
                    .alert(isPresented: $mapData.alertValue) {
                                        Alert(
                                            title: Text(mapData.alertDetail.title),
                                            message: Text(mapData.alertDetail.message)
                                        )
                                    }
                
                VStack{
                    Spacer()
                    LocationAndGlobeButtonComp()
                }
                if mapData.showInterestListView{
                    Color.black
                        .opacity(0.5)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.default) {
                                mapData.showInterestListView.toggle()
                            }
                        }
                }
                VStack{
                    HomeHeaderComp()
                     Spacer()
                }
                
                MoreInfoView(isShowing: $mapData.showMoreInfoView)
            }
        }
    }
}

struct ProtoHomeView_Previews: PreviewProvider {
    static var previews: some View {
        ProtoHomeView()
            .environmentObject(MapUIViewModel())
    }
}

