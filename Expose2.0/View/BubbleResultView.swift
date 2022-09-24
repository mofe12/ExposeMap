//
//  BubbleResultView.swift
//  Expose
//
//  Created by Eyimofe Oladipo on 9/20/22.
//

import SwiftUI

struct BubbleResultView: View {
    @EnvironmentObject var viewModel : ResultPageViewModel
    var body: some View {
        VStack() {
            ScrollView {
                
                HStack{
                    Text("Your interest")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    
                    Spacer()
                }
                HStack{
                    Text("Your result show that you are interested in alot, Here are some of those things.")
                        .foregroundColor(.gray)

                }
                
                ForEach(viewModel.interestEntities) { item in
                    if let image = item.image {
                        BubblesComp(image: UIImage(data: image) ?? UIImage(systemName: "questionmark.square.fill")!, text: item.interest ?? "")
                    }
                }
            }
        }
    }
}

struct BubbleResultView_Previews: PreviewProvider {
    static var previews: some View {
        BubbleResultView()
            .environmentObject(ResultPageViewModel())
    }
}
