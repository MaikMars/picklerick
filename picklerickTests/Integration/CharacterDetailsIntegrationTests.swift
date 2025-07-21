//
//  CharacterDetailsIntegrationTests.swift
//  picklerickTests
//
//  Created by Miki on 21/7/25.
//

import XCTest
@testable import picklerick

@MainActor
final class EpisodesIntegrationTests: XCTestCase {

    var viewModel: CharacterDetailsViewModelImpl!

    override func setUp() async throws {
        let character = Character(
            id: 1,
            name: "Rick Sanchez",
            status: "Alive",
            species: "Human",
            type: nil,
            gender: "Male",
            imageURL: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            originName: "Earth",
            episodes: [1, 2, 3, 42]
        )
        viewModel = CharacterDetailsViewModelImpl(character: character)
    }

    func testLoadEpisodes_groupsEpisodesBySeason() async throws {
        await viewModel.loadEpisodes()
        
        XCTAssertFalse(viewModel.seasonSections.isEmpty, "Expected episodes grouped by season")
        
        let allEpisodes = viewModel.seasonSections.flatMap { $0.episodes }
        XCTAssertGreaterThan(allEpisodes.count, 0, "Expected episodes to be loaded")
    }
    
    func testLoadEpisodes_groupsBy2Seasons() async throws {
        await viewModel.loadEpisodes()
        
        XCTAssertTrue( viewModel.seasonSections.count == 2, "Expected 2 seasons")
    }
}
