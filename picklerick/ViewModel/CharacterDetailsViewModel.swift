//
//  CharacterDetailsViewModel.swift
//  picklerick
//
//  Created by Miki on 18/7/25.
//

import Foundation

@MainActor
protocol CharacterDetailsViewModel: ObservableObject {
    func loadEpisodes() async throws
}

class CharacterDetailsViewModelImpl: CharacterDetailsViewModel {

    
    init(
        episodeService: EpisodeService = EpisodeServiceImpl(),
        isLoading: Bool = false,
        character: Character
    ) {
        self.episodeService = episodeService
        self.isLoading = isLoading
        self.character = character
    }
    
    private let episodeService: EpisodeService
    private let character: Character
    
    @Published var isLoading = false
    @Published var seasonSection: [SeasonSection] = []
    
    func loadEpisodes() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            let episodes = try await episodeService.fetchEpisodes(
                episodes: character.episodes
            )
            seasonSection = groupEpisodesBySeason(episodes)
        } catch {
            print("error loading episodes for character")
        }
    }
    
    internal func groupEpisodesBySeason(_ episodes: [Episode]) -> [SeasonSection] {
        let grouped = Dictionary(grouping: episodes) { $0.season }
        return grouped.map { season, episodes in
            SeasonSection(
                id: season,
                season: season,
                episodes: episodes
                    .sorted { ($0.episodeNumber) < ($1.episodeNumber )
                    })
        }
        .sorted { $0.season < $1.season }
    }
}
    
