//
//  TransloaditConcurrency.swift
//  TransloaditKit
//
//  Created by Benjamin Wong on 2024/10/11.
//

import Foundation

public extension Transloadit {
  class TransloaditConcurrency {
    private let transloadit: Transloadit
    
    init(transloadit: Transloadit) {
      self.transloadit = transloadit
    }
    
    public func createAssembly(
        templateId: String,
        steps: [Step],
        andUpload file: URL,
        customFields: [String: String] = [:]) async throws {
          return try await withCheckedThrowingContinuation { continuation in
            transloadit.createAssembly(templateId: templateId, steps: steps, andUpload: [file]) { result in
              switch result {
              case .success:
                break
              case .failure(let failure):
                continuation.resume(throwing: failure)
              }
            }.pollAssemblyStatus { result in
              switch result {
              case .success(let success):
                if success.processingStatus == .completed {
                  continuation.resume(returning: ())
                }
              case .failure(let failure):
                continuation.resume(throwing: failure)
              }
            }
          }
    }
  }
  
  var async: TransloaditConcurrency {
    TransloaditConcurrency(transloadit: self)
  }
}
