//
//  TransloaditKitExampleApp.swift
//  TransloaditKitExample
//
//  Created by Tjeerd in ‘t Veen on 12/10/2021.
//

import SwiftUI
import TransloaditKit
import Atlantis

final class MyUploader: ObservableObject {
    let transloadit: Transloadit
    
    func upload(_ urls: [FileInfo]) {
        let resizeStep = StepFactory.makeResizeStep(width: 200, height: 100)
//        transloadit.createAssembly(templateId: "70e0b69e8a7a4f63bae7f1292c07cea1", andUpload: urls) { result in
//            switch result {
//            case .success(let assembly):
//                print("Retrieved \(assembly)")
//            case .failure(let error):
//                print("Assembly error \(error)")
//            }
//        }.pollAssemblyStatus { result in
//            switch result {
//            case .success(let assemblyStatus):
//                print("Received assemblystatus \(assemblyStatus)")
//            case .failure(let error):
//                print("Caught polling error \(error)")
//            }
//        }
//        transloadit.createAssembly(steps: [resizeStep], andUpload: urls.map({ $0.0 }), customFields: ["hello": "world"]) { result in
//            switch result {
//            case .success(let assembly):
//                print("Retrieved \(assembly)")
//            case .failure(let error):
//                print("Assembly error \(error)")
//            }
//        }.pollAssemblyStatus { result in
//            switch result {
//            case .success(let assemblyStatus):
//                print("Received assemblystatus \(assemblyStatus)")
//            case .failure(let error):
//                print("Caught polling error \(error)")
//            }
//        }
        for file in urls {
            upload(url: file.path, mime: file.mime, fileExtension: file.fileExtension)
        }
    }
    
    private func upload(url: URL, mime: String, fileExtension: String) {
//        let objectName = Date().formatted(.iso8601)
        let objectName = "bc15a1d6-4b2d-402d-bc3b-bc8bd67a2733/media/\(UUID().uuidString).\(fileExtension)"
        print("objectName: \(objectName)")
        let supabaseStep = StepFactory.makeExportToSupabaseStep(token: "Bearer eyJhbGciOiJIUzI1NiIsImtpZCI6Ikd4cFZmS1NOeFlnL3RueTQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3R5cWJqdmNyY29qc3Rhbm1zaWxiLnN1cGFiYXNlLmNvL2F1dGgvdjEiLCJzdWIiOiJiYzE1YTFkNi00YjJkLTQwMmQtYmMzYi1iYzhiZDY3YTI3MzMiLCJhdWQiOiJhdXRoZW50aWNhdGVkIiwiZXhwIjoxNzI4NjMwMDM1LCJpYXQiOjE3Mjg2MjY0MzUsImVtYWlsIjoiaXdhbmdrYWltaW5AZ21haWwuY29tIiwicGhvbmUiOiIiLCJhcHBfbWV0YWRhdGEiOnsicHJvdmlkZXIiOiJnb29nbGUiLCJwcm92aWRlcnMiOlsiZ29vZ2xlIl19LCJ1c2VyX21ldGFkYXRhIjp7ImF2YXRhcl91cmwiOiJodHRwczovL2xoMy5nb29nbGV1c2VyY29udGVudC5jb20vYS9BQ2c4b2NJVUVqS2kxTk5HVXV5NUtXWlRYNGdiTFl5VXhMZkFfb1NNZk5aZGRpcUFGRmlTdFE9czk2LWMiLCJlbWFpbCI6Iml3YW5na2FpbWluQGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJmdWxsX25hbWUiOiJCZW5qYW1pbiBXb25nIiwiaGFuZGxlIjoiYmVuamFtaW4iLCJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJuYW1lIjoiQmVuamFtaW4gV29uZyIsInBob25lX3ZlcmlmaWVkIjpmYWxzZSwicGljdHVyZSI6Imh0dHBzOi8vbGgzLmdvb2dsZXVzZXJjb250ZW50LmNvbS9hL0FDZzhvY0lVRWpLaTFOTkdVdXk1S1daVFg0Z2JMWXlVeExmQV9vU01mTlpkZGlxQUZGaVN0UT1zOTYtYyIsInByb3ZpZGVyX2lkIjoiMTE3NDE4NDQ2MDg4NTQ3ODc5NjgxIiwic3ViIjoiMTE3NDE4NDQ2MDg4NTQ3ODc5NjgxIn0sInJvbGUiOiJhdXRoZW50aWNhdGVkIiwiYWFsIjoiYWFsMSIsImFtciI6W3sibWV0aG9kIjoicGFzc3dvcmQiLCJ0aW1lc3RhbXAiOjE3Mjg2MjY0MzR9XSwic2Vzc2lvbl9pZCI6IjAwZGZjOTI4LTM4ZDUtNDc2Mi1hNzkwLWM4ZGIxOWY0YzEyYSIsImlzX2Fub255bW91cyI6ZmFsc2V9.K9G2SqQdPDx1nWrN7PGLiNgA0gTjR_V-kWauu1bXAW8", bucketName: "public-user-assets", objectName: objectName, contentType: mime)
        transloadit.createAssembly(templateId: "3b10b8f60524435d8804a32508c71987", steps: [supabaseStep], andUpload: [url]) { result in
            switch result {
            case .success(let assembly):
                print("Retrieved \(assembly)")
            case .failure(let error):
                print("Assembly error \(error)")
            }
        }.pollAssemblyStatus { result in
            switch result {
            case .success(let assemblyStatus):
                print("Received assemblystatus \(assemblyStatus)")
            case .failure(let error):
                print("Caught polling error \(error)")
            }
        }
    }
    
    init() {
//        let credentials = Transloadit.Credentials(key: "2727b1b19fa14210b46ffde5ab0ac73c", secret: "f19992a01d710b2122a472edde02764071cb584f")
//        let credentials = Transloadit.Credentials(key: "5ededa03eaea4a61a2243ef29139242e", secret: "")
        let credentials = Transloadit.Credentials(key: "XcojjgNYk5rnRCs0MCbwsFDx2K60cfNA", secret: "Ghx4kZ0vlkU4Xc9waS2mG4IRFkz5BCdbocLGLUmt")
        self.transloadit = Transloadit(credentials: credentials, session: URLSession.shared)
        self.transloadit.fileDelegate = self
    }
}

enum StepFactory {
    static func makeExportToSupabaseStep(token: String, bucketName: String, objectName: String, contentType: String) -> Step {
        Step(name: "exported", robot: "/tus/store", options: [
            "use": ":original",
            "endpoint": "https://app.protocols.fyi/storage/v1/upload/resumable",
            "headers": [
                "Authorization": token
            ],
            "chunkSize": 6 * 1024 * 1024,
            "allowedMetaFields": ["bucketName", "objectName", "contentType", "cacheControl"],
            "removeFingerprintOnSuccess": true,
            "metadata": [
                "bucketName": bucketName,
                "objectName": objectName,
                "contentType": contentType
            ]
        ])
    }
    
    static func makeResizeStep(width: Int, height: Int) -> Step {
        Step(name: "resize", robot: "/image/resize", options: ["width": width,
                                                               "height": height,
                                                               "resize_strategy": "fit",
                                                               "result": true])
    }
    
}

extension MyUploader: TransloaditFileDelegate {
    func progressFor(assembly: Assembly, bytesUploaded: Int, totalBytes: Int, client: Transloadit) {
        print("Progress for \(assembly) is \(bytesUploaded) / \(totalBytes)")
    }
    
    func totalProgress(bytesUploaded: Int, totalBytes: Int, client: Transloadit) {
        print("Total bytes \(totalBytes)")
    }
    
    func didErrorOnAssembly(errror: Error, assembly: Assembly, client: Transloadit) {
        print("didErrorOnAssembly")
    }
    
    func didError(error: Error, client: Transloadit) {
        print("didError")
    }
    
    func didCreateAssembly(assembly: Assembly, client: Transloadit) {
        print("didCreateAssembly \(assembly)")
    }
    
    func didFinishUpload(assembly: Assembly, client: Transloadit) {
        print("didFinishUpload")
        
        transloadit.fetchStatus(assemblyURL: assembly.url) { result in
            print("status result \(result)")
        }
    }
    
    func didStartUpload(assembly: Assembly, client: Transloadit) {
        print("didStartUpload")
    }
}

@main
struct TransloaditKitExampleApp: App {
    @ObservedObject var uploader: MyUploader
    
    init() {
        self.uploader = MyUploader()
        // Atlantis.start(hostName: "")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(uploader: uploader)
        }
    }
}
