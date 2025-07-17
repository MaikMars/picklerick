//
//  RnMCharacterService.swift
//  picklerick
//
//  Created by Miki on 15/7/25.
//

import Foundation


protocol RnMCharacterService {
    func fetchCharacters(page: Int, query: String?, filters: [String: String]) async throws -> [Character]
}

extension RnMCharacterService {
    func fetchCharacters(page: Int, query: String? = nil, filters: [String: String] = [:]) async throws -> [Character] {
        try await fetchCharacters(page: page, query: query, filters: filters)
    }
}

class RnMCharacterServiceImpl: RnMCharacterService {
    private let session: URLSession
    private let baseURL: String
    private var cache: [String: [Character]] = [:]
    
    init(
        session: URLSession = .shared,
        baseURL: String = "https://rickandmortyapi.com/api/character"
    ) {
        self.session = session
        self.baseURL = baseURL
    }
    
    func fetchCharacters(page: Int, query: String? = nil, filters: [String: String] = [:]) async throws -> [Character] {
        let key = cacheKey(page: page, query: query, filters: filters)
        
        if let cached = cache[key] {
            print("✅ Loaded from cache: \(key)")
            return cached
        }
        
        let url = try url(for: page, query: query, filters: filters)
        
        do {
            let (data, _) = try await session.data(from: url)
            let response = try JSONDecoder().decode(
                CharacterResponseDTO.self,
                from: data
            )
            let characters = response.results.map { $0.toDomain() }
            cache[key] = characters
            return characters
        } catch is DecodingError {
            throw CharacterServiceError.decodingError
        } catch {
            throw CharacterServiceError.networkError(error)
        }
    }
    
    internal func url(for page: Int, query: String?, filters: [String: String]) throws -> URL {
        var components = URLComponents(string: baseURL)
        var queryItems = [URLQueryItem(name: "page", value: "\(page)")]
        
        if let query, !query.isEmpty {
            queryItems.append(URLQueryItem(name: "name", value: query))
        }
        
        for (key, value) in filters.sorted(by: { $0.key < $1.key }) {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        components?.queryItems = queryItems
        
        guard let url = components?.url,
              url.scheme == "https" || url.scheme == "http" else {
            throw CharacterServiceError.invalidURL
        }
        
        return url
    }
    
    private func cacheKey(page: Int, query: String?, filters: [String: String]) -> String {
        let queryPart = query?.lowercased() ?? ""
        let filtersPart = filters.sorted(by: { $0.key < $1.key })
            .map { "\($0.key)=\($0.value.lowercased())" }
            .joined(separator: "&")
        return "page:\(page)|query:\(queryPart)|filters:\(filtersPart)"
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
