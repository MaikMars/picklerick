//
//  EpisodeDTO+Mapper.swift
//  picklerick
//
//  Created by Miki on 18/7/25.
//

import Foundation


extension EpisodeDTO {
    func toDomain() -> Episode {
        let pattern = #"S(\d+)E(\d+)"#
        let regex = try? NSRegularExpression(pattern: pattern)

        var seasonNumber: Int = 0
        var episodeNumber: Int = 0

        if let match = regex?.firstMatch(
            in: episode,
            range: NSRange(episode.startIndex..., in: episode)
        ),
           let seasonRange = Range(match.range(at: 1), in: episode),
           let episodeRange = Range(match.range(at: 2), in: episode) {
                
            seasonNumber = Int(episode[seasonRange]) ?? 0
            episodeNumber = Int(episode[episodeRange]) ?? 0
        }

        return Episode(
            id: id,
            name: name,
            season: seasonNumber,
            episodeNumber: episodeNumber
        )
    }
}

