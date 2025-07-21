//
//  EpisodeService.swift
//  picklerick
//
//  Created by Miki on 18/7/25.
//

import Foundation

protocol EpisodeService {
    func fetchEpisodes(episodes: [Int]) async throws -> [Episode]
}

class EpisodeServiceImpl: RMBaseService, EpisodeService {
    private var cache: [String: [Episode]] = [:]
       
    init(session: URLSession = .shared) {
        super.init(
            session: session,
            baseURL: "https://rickandmortyapi.com/api/episode"
        )
    }
       
    func fetchEpisodes(episodes: [Int]) async throws -> [Episode] {
        let url = try url(for: episodes)
        let key = episodes.map { String($0) }.joined(separator: ",")
        
        if let cached = cache[key] {
            return cached
        }
        
        let data = try await fetchData(from: url, cacheKey: key)
        let decoder = JSONDecoder()
        
        if let episodesDecoded = try? decoder.decode(
            [EpisodeDTO].self,
            from: data
        ) {
            let episodes = episodesDecoded.map { $0.toDomain() }
            cache[key] = episodes
            return episodes
        }
        
        if let singleEpisode = try? decoder.decode(
            EpisodeDTO.self,
            from: data
        ) {
            let episodes = [singleEpisode.toDomain()]
            cache[key] = episodes
            return episodes
        }
        
        throw RMServiceError.decodingError
    }
       
    internal func url(for episodes: [Int]) throws -> URL {
        let path = episodes.map { String($0) }.joined(separator: ",")
        let fullURL = "\(baseURL)/\(path)"
        guard let url = URL(string: fullURL) else {
            throw ServiceError.invalidURL
        }
        return url
    }
}


