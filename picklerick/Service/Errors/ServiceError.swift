//
//  ServiceError.swift
//  picklerick
//
//  Created by Miki on 18/7/25.
//

import Foundation

enum ServiceError: Error, Equatable {
    case invalidURL
    case decodingError
    case networkError(Error)
    
    static func == (lhs: ServiceError, rhs: ServiceError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL), (.decodingError, .decodingError):
            return true
        case (.networkError, .networkError):
            return true
        default:
            return false
        }
    }
}


