//
//  MoreInfoView.swift
//  Expose2.0
//
//  Created by Eyimofe Oladipo on 5/19/22.
//

import SwiftUI

struct MoreInfoView: View {
    @EnvironmentObject var viewModel : MapUIViewModel
    @Binding var isShowing: Bool
    @State private var isDragging = false
    
    @State private var currHeight: CGFloat = 500
    let minHeight: CGFloat = 500
    let maxHeight: CGFloat = 700
    
    let startOpacity: Double = 0.4
    let endOpacity: Double = 0.8
    
    var dragPercentage: Double{
        let res = Double((currHeight-minHeight) / (maxHeight-minHeight))
        return max(0, min(1, res))
    }
    
    var body: some View {
        ZStack(alignment: .bottom){
            if isShowing{
                Color.black
                    .opacity(startOpacity+(endOpacity-startOpacity)*dragPercentage)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing = false
                    }
                mainView
                    .transition(.move(edge: .bottom))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut)
    }
    
    var mainView: some View{
        VStack(alignment: .leading){
            ZStack{
                Capsule()
                    .frame(width: 60, height: 6)
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.00001))
            // Explicity wrapping because I have it covered for when there is no value
            Text(viewModel.moreInfoPlace.name!)
                .font(.title)
            Text("\(viewModel.moreInfoPlace.addressNumber!) \(viewModel.moreInfoPlace.streetName!) \(viewModel.moreInfoPlace.city!), \(viewModel.moreInfoPlace.state!) \(viewModel.moreInfoPlace.zipCode!) \(viewModel.moreInfoPlace.country!)")
            
            Spacer()
        }
        .padding()
        .frame(height: currHeight)
        .frame(maxWidth: .infinity)
        .background(
            // HACK FOR ROUNDED EDGE only on top
            ZStack{
                RoundedRectangle(cornerRadius: 30)
                Rectangle()
                    .frame(height: currHeight/2)
            }
                .foregroundColor(Color("BackGroundColor"))
        )
        .gesture(dragGesture)
        .animation(isDragging ? nil: .easeInOut(duration: 0.45))
        .onDisappear{
            currHeight = minHeight
        }
    }
    
    @State private var prevDragTranslation = CGSize.zero
    var dragGesture: some Gesture{
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { val in
                
                if !isDragging{
                    isDragging = true
                }
                let dragAmount = val.translation.height - prevDragTranslation.height
                if currHeight > maxHeight || currHeight < minHeight{
                    currHeight -= dragAmount / 6
                }else{
                    currHeight -= dragAmount
                    
                }
                prevDragTranslation = val.translation
            }
            .onEnded { val in
                prevDragTranslation = .zero
                isDragging = false
                if currHeight > maxHeight{
                    currHeight = maxHeight
                }
                else if currHeight < minHeight{
                    currHeight = minHeight
                }
                
                if val.translation.height > 0 && currHeight == 500 {
                    isShowing = false
                    
                }
            }
    }
}

struct MoreInfoView_Previews: PreviewProvider {
    static var previews: some View {
        MoreInfoView(isShowing: .constant(true))
            .environmentObject(MapUIViewModel())
        //LocationMapAnnotationView()
    }
}
