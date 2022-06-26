//
//  NewQuickFile.swift
//  Expose2.0
//
//  Created by Eyimofe Oladipo on 5/20/22.
//

import SwiftUI
import MapKit
import CoreLocationUI

struct NewQuickFile: View {

    var body: some View {
        VStack(spacing:0) {
            Button {
            } label: {
                Image(systemName: "photo.fill")
                    //.frame(width: , height: )
                    .frame(maxWidth:  .infinity, maxHeight: .infinity)
                    .padding(.bottom, 1)
                    .foregroundColor(.gray)
            }
            Divider()
                .frame(width: 59)
            ZStack {
                Button {
                } label: {
                    Image(systemName:"location.fill")
                        .frame(maxWidth:  .infinity, maxHeight: .infinity)
                        .foregroundColor(.gray)
                        .padding(.top, 1)
                }

                
                
            }
        }
        .font(.title2)
        .frame(width: 50, height: 120)
        .background(.thickMaterial)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 15)
        
        
    }
}

struct NewQuickFile_Previews: PreviewProvider {
    static var previews: some View {
        NewQuickFile()
            .preferredColorScheme(.dark)
    }
}

struct MyLabelStyle: LabelStyle {
    let color: Color

    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.title
            configuration.icon
                .symbolVariant(.fill)
                .foregroundColor(.red)
        }
    }
}

