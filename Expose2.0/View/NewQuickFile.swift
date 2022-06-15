//
//  NewQuickFile.swift
//  Expose2.0
//
//  Created by Eyimofe Oladipo on 5/20/22.
//

import SwiftUI
import MapKit
import OrderedCollections

struct NewQuickFile: View {
    @State var testArray = [1,2,3,4]
    @State var orderedset = OrderedSet([1,2])
    var body: some View {
        VStack {
            ForEach(orderedset, id: \.self){ number in
                    Text("\(number)")
            }
        }.onAppear{
            orderedset.append(1)
        }
    }
    init(){
        orderedset = OrderedSet(testArray)
    }
}

struct NewQuickFile_Previews: PreviewProvider {
    static var previews: some View {
        NewQuickFile()
    }
}
