//
//  RMBaseService.swift
//  picklerick
//
//  Created by Miki on 18/7/25.
//

import Foundation

class RMBaseService {
    internal let session: URLSession
    internal let baseURL: String
    internal var dataCache: [String: Data] = [:]
    
    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }

    internal func fetchData(from url: URL, cacheKey: String? = nil) async throws -> Data {
        if let key = cacheKey, let cachedData = dataCache[key] {
            print("✅ Loaded from cache: \(key)")
            return cachedData
        }
        do {
            let (data, _) = try await session.data(from: url)
            
            if let key = cacheKey {
                dataCache[key] = data
            }
            return data
        } catch {
            throw RMServiceError.networkError(error)
        }
    }
}



enum RMServiceError: Error, Equatable {
    case invalidURL
    case decodingError
    case networkError(Error)
    
    static func == (lhs: RMServiceError, rhs: RMServiceError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL), (.decodingError, .decodingError):
            return true
        case (.networkError, .networkError):
            return true // o false según si quieres distinguir errores concretos
        default:
            return false
        }
    }
}

