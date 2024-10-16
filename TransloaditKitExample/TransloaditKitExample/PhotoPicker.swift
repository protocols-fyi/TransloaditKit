//
//  PhotoPicker.swift
//  TransloaditKitExample
//
//  Created by Tjeerd in ‘t Veen on 12/10/2021.
//

import SwiftUI
import UIKit
import PhotosUI
import TUSKit
import AVFoundation
import MobileCoreServices

struct FileInfo {
    var path: URL
    var mime: String
    var fileExtension: String
}

struct PhotoPicker: UIViewControllerRepresentable {

    var didPickPhotos: ([FileInfo]) -> Void
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        configuration.selectionLimit = 30
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // Use a Coordinator to act as your PHPickerViewControllerDelegate
    class Coordinator: PHPickerViewControllerDelegate {
      
        private let parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            dataFrom(pickerResults: results) { [unowned self] urls in
                self.parent.didPickPhotos(urls)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func dataFrom(pickerResults: [PHPickerResult], completed: @escaping ([FileInfo]) -> Void) {
            let identifiers = pickerResults.compactMap(\.assetIdentifier)
            
            let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
            var assetURLs = [FileInfo]()
            
            var expectedCount = pickerResults.count // Can't rely on count in enumerateObjects in Xcode 13
            fetchResult.enumerateObjects { asset, count, _ in
                asset.getURLAndMIME { fileInfo in
                    expectedCount -= 1
                    guard let fileInfo = fileInfo else {
                        print("No url found for asset")
                        return
                    }
                    print(fileInfo)
                    assetURLs.append(fileInfo)

                    if expectedCount == 0 {
                        completed(assetURLs)
                    }
                }
                
            }
           
        }
        
        deinit {
            
        }
    }
}

private extension PHAsset {
    // From https://stackoverflow.com/questions/38183613/how-to-get-url-for-a-phasset
    func getURLAndMIME(completionHandler : @escaping ((FileInfo?) -> Void)){
        if self.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            self.requestContentEditingInput(with: options, completionHandler: {(contentEditingInput: PHContentEditingInput?, info: [AnyHashable : Any]) -> Void in
                let uti: UTType?
                if let i = contentEditingInput?.uniformTypeIdentifier {
                    uti = UTType(i)
                } else {
                    uti = nil
                }
                guard let url = contentEditingInput?.fullSizeImageURL, let mime = uti?.preferredMIMEType, let fileExtension = uti?.preferredFilenameExtension else {
                    completionHandler(nil)
                    return
                }
                completionHandler(.init(path: url, mime: mime, fileExtension: fileExtension))
            })
        } else if self.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: { asset, audioMix, info in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl: URL = urlAsset.url as URL
                    let pathExtension = localVideoUrl.pathExtension
                    let uti = UTType(filenameExtension: pathExtension)
                    guard let mime = uti?.preferredMIMEType, let fileExtension = uti?.preferredFilenameExtension else {
                        completionHandler(nil)
                        return
                    }
                    completionHandler(.init(path: localVideoUrl, mime: mime, fileExtension: fileExtension))
                } else {
                    completionHandler(nil)
                }

            })
        }
    }
}
