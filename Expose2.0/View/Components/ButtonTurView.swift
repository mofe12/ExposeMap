//
//  ButtonTurView.swift
//  Expose
//
//  Created by Eyimofe Oladipo on 8/25/22.
//

import SwiftUI

struct ButtonTurView: View{
    @State var text: String
    var body: some View{
        VStack {
            Text(text)
                .foregroundColor(.primary)
                .font(.title2)
                .fontWeight(.black)
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(Color("Turquoise"))
                .cornerRadius(16)
                .padding(.horizontal, 16)
        }
    }
}

struct ButtonTurView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonTurView(text: "LOL")
    }
}
