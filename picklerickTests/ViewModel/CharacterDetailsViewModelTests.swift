//
//  CharacterDetailsViewModelTests.swift
//  picklerickTests
//
//  Created by Miki on 20/7/25.
//

import Foundation
import XCTest
@testable import picklerick

@MainActor
final class CharacterDetailsViewModelTests: XCTestCase {
    
    var service: EpisodeServiceMock!
    var viewModel: CharacterDetailsViewModelImpl!

    override func setUp() {
        service = EpisodeServiceMock()
        service.fetchEpisodesResponse = [ Episode(id: 1, name: "Pilot", season: 1, episodeNumber: 1)
        ]
        viewModel = CharacterDetailsViewModelImpl(episodeService: service, character: Character(id: 1, name: "Rick Sanchez", status: "Alive", species: "Human", type: nil, gender: "Male", imageURL: "", originName: "Earth", episodes: [1,2,3,4]))
    }
    
    func testLoadEpisodes_callsService() async {
        //When
        await viewModel.loadEpisodes()
        
        //Then
        XCTAssertTrue(service.fetchEpisodesCalled)
    }

    func testLoadEpisodes_responseSuccess() async {
        //When
        await viewModel.loadEpisodes()
        
        //Then
        let seasonSection = viewModel.seasonSections
        XCTAssertEqual(seasonSection.count, 1)
    }
    
    func testLoadEpisodes_setsIsLoadingToFalse_onSuccess() async {
        //When
        await viewModel.loadEpisodes()
        
        //Then
        XCTAssertFalse(viewModel.isLoading)
    }
}
