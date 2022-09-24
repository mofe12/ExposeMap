//
//  PhotoPickerUIKitView.swift
//  Expose2.0
//
//  Created by Eyimofe Oladipo on 5/31/22.
//

import SwiftUI
import PhotosUI

struct PhotoPickerUIKitView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let onResultsHandler: ([PHPickerResult]) -> Void
    
    func makeCoordinator() -> PhotosPickerViewCoordinator {
      PhotosPickerViewCoordinator(isPresented: _isPresented, onResultsHandler: onResultsHandler)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
      var configuration = PHPickerConfiguration(photoLibrary: .shared())
      configuration.filter = .any(of: [.images])
        configuration.selectionLimit = 10
      configuration.selection = .ordered
      let controller = PHPickerViewController(configuration: configuration)
      controller.delegate = context.coordinator
      return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
      
    }
  }

  final class PhotosPickerViewCoordinator: PHPickerViewControllerDelegate {
    let onResultsHandler: ([PHPickerResult]) -> Void
    @Binding var isPresented: Bool
    
    init(isPresented: Binding<Bool>, onResultsHandler: @escaping ([PHPickerResult]) -> Void) {
      self._isPresented = isPresented
      self.onResultsHandler = onResultsHandler
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
      let imageResults = results.filter { $0.itemProvider.canLoadObject(ofClass: UIImage.self) }
      onResultsHandler(imageResults)
      isPresented = false
    }
  }
