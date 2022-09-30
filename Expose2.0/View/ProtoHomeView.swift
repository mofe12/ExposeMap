//
//  ProtoHomeView.swift
//  Expose
//
//  Created by Eyimofe Oladipo on 9/19/22.
//

import SwiftUI

struct ProtoHomeView: View {
    @EnvironmentObject var mapData : MapUIViewModel
    @State var moreInfoSheetView = false
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
                        .zIndex(2.0)
                     Spacer()
                }
                
                MoreInfoView(isShowing: $mapData.showMoreInfoView)
            } // MARK: ZSTACK
        }
        .sheet(isPresented: $moreInfoSheetView) {
            if #available(iOS 16.0, *) {
                MoreInfoComp()
                    .presentationDetents([.medium,.large])
            }
        }
        .sync($mapData.showHalfSheetView, with: $moreInfoSheetView)
    }
}

struct ProtoHomeView_Previews: PreviewProvider {
    static var previews: some View {
        ProtoHomeView()
            .environmentObject(MapUIViewModel())
    }
}

