//
//  EpisodeServiceMock.swift
//  picklerickTests
//
//  Created by Miki on 20/7/25.
//

import Foundation
@testable import picklerick

class EpisodeServiceMock : EpisodeService {

    var fetchEpisodesCalled = false
    var fetchEpisodesResponse: [Episode] = []
 
    func fetchEpisodes(episodes: [Int]) async throws -> [picklerick.Episode] {
        fetchEpisodesCalled = true
        return fetchEpisodesResponse
    }
}
