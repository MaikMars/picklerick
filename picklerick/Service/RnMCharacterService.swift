//
//  RnMCharacterService.swift
//  picklerick
//
//  Created by Miki on 15/7/25.
//

import Foundation


protocol RnMCharacterService {
    func fetchAllCharacters(page: Int) async throws -> [Character]
}

class RnMCharacterServiceImpl: RnMCharacterService {
    private let session: URLSession
    private let baseURL: String
    private var cache: [Int: [Character]] = [:]
    
    init(
        session: URLSession = .shared,
        baseURL: String = "https://rickandmortyapi.com/api/character")
    {
        self.baseURL = baseURL
        self.session = session
    }
  
    func fetchAllCharacters(page: Int) async throws -> [Character] {
        if let cached = cache[page] {
            return cached
        }
        do {
            let (data, _) = try await session.data(from: url(for: page))
            let response = try JSONDecoder().decode(
                CharacterResponseDTO.self,
                from: data
            )
            let characters = response.results.map{$0.toDomain()}
            cache[page] = characters
            return characters
        } catch let decodingError as DecodingError {
            throw CharacterServiceError.decodingError
        } catch {
            throw CharacterServiceError.networkError(error)
        }
    }
    
    internal func url(for page: Int) throws -> URL {
           guard let url = URL(string: "\(baseURL)?page=\(page)"),
                 url.scheme == "https" || url.scheme == "http" else {
               throw CharacterServiceError.invalidURL
           }
           return url
       }
}


enum CharacterServiceError: Error, Equatable {
    case invalidURL
    case decodingError
    case networkError(Error)
    
    static func == (lhs: CharacterServiceError, rhs: CharacterServiceError) -> Bool {
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
