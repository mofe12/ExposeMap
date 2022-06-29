//
//  Extensions.swift
//  Expose
//
//  Created by Eyimofe Oladipo on 6/26/22.
//

import Foundation
import SwiftUI



extension UIImage {
    func toPngString() -> String? {
        let data = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
  
    func toJpegString(compressionQuality cq: CGFloat) -> String? {
        let data = self.jpegData(compressionQuality: cq)
       // return data?.base64EncodedString(options: .endLineWithLineFeed)
        return data?.base64EncodedString(options: .lineLength64Characters)
    }
}

extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}
