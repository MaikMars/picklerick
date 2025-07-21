//
//  CharacterService.swift
//  picklerick
//
//  Created by Miki on 15/7/25.
//

import Foundation

protocol CharacterService {
    func fetchCharacters(page: Int, query: String?, filters: [String: String]) async throws -> [Character]
}

extension CharacterService {
    func fetchCharacters(page: Int, query: String? = nil, filters: [String: String] = [:]) async throws -> [Character] {
        try await fetchCharacters(page: page, query: query, filters: filters)
    }
}

class CharacterServiceImpl: RMBaseService, CharacterService {
    private var cache: [String: [Character]] = [:]

    override init(session: URLSession = .shared,
                  baseURL: String = "https://rickandmortyapi.com/api/character"
    ) {
        super.init(session: session, baseURL: baseURL)
    }


    func fetchCharacters(page: Int, query: String? = nil, filters: [String: String] = [:]) async throws -> [Character] {
        let url = try url(for: page, query: query, filters: filters)
        let cacheKey = cacheKey(page: page, query: query, filters: filters)
            
        if let cached = cache[cacheKey] {
            return cached
        }
        let data = try await fetchData(from: url, cacheKey: cacheKey)

        
        if let response = try? JSONDecoder().decode(
            CharacterResponseDTO.self,
            from: data
        ) {
            let characters = response.results.map { $0.toDomain() }
            cache[cacheKey] = characters
            return characters
        }
        
        if let _ =  try? JSONDecoder().decode(
            [String: String].self,
            from: data
        ) {
            return []
        }
        throw RMServiceError.decodingError
    
    }
    
    
    
    internal func url(for page: Int, query: String?, filters: [String: String]) throws -> URL {
        guard var components = URLComponents(string: baseURL) else
        
        { throw ServiceError.invalidURL }
        
        var queryItems = [URLQueryItem(name: "page", value: "\(page)")]

        if let query, !query.isEmpty {
            queryItems.append(URLQueryItem(name: "name", value: query))
        }

        for (key, value) in filters.sorted(by: { $0.key < $1.key }) {
            queryItems.append(URLQueryItem(name: key, value: value))
        }

        components.queryItems = queryItems

        guard let url = components.url else { throw ServiceError.invalidURL }
        return url
    }

    private func cacheKey(page: Int, query: String?, filters: [String: String]) -> String {
        let queryPart = query?.lowercased() ?? ""
        let filtersPart = filters
            .sorted(by: { $0.key < $1.key })
            .map { "\($0.key)=\($0.value.lowercased())" }
            .joined(separator: "&")
        return "page:\(page)|query:\(queryPart)|filters:\(filtersPart)"
    }
}
