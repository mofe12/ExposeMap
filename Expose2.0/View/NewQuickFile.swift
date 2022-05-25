//
//  NewQuickFile.swift
//  Expose2.0
//
//  Created by Eyimofe Oladipo on 5/20/22.
//

import SwiftUI
import MapKit

struct NewQuickFile: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37, longitude: -95), latitudinalMeters: 10000000, longitudinalMeters: 10000000)
    var body: some View {
        Map(coordinateRegion: $region)
    }
}

struct NewQuickFile_Previews: PreviewProvider {
    static var previews: some View {
        NewQuickFile()
    }
}
