//
//  LocationMapAnnotationView.swift
//  Expose2.0
//
//  Created by Eyimofe Oladipo on 5/18/22.
//

import SwiftUI

struct LocationMapAnnotationView: View {
    //@State private var showMoreInfoView = false
    @EnvironmentObject var viewModel : MapUIViewModel
    var body: some View {
        ZStack {
                VStack(spacing: 0){
                    RoundedRectangle(cornerRadius: 8)
                        .scaledToFit()
                        .frame(width: 40, height:40)
                    
                    Image(systemName: "triangle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 10, height: 10)
                        .rotationEffect(Angle(degrees: 180))
                        .offset(y: -4)
                        .padding(.bottom, 40)
                    
        }
            //MoreInfoView(isShowing: $showMoreInfoView)
        }
        
    }
}

struct LocationMapAnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationMapAnnotationView()
    }
}
