//
//  CharactersGridIntegrationTests.swift
//  picklerickTests
//
//  Created by Miki on 21/7/25.
//

import XCTest
@testable import picklerick

@MainActor
final class CharactersGridIntegrationTests: XCTestCase {

    var viewModel: CharactersGridViewModelImpl!

    override func setUp() async throws {
        let service = CharacterServiceImpl()
        viewModel = CharactersGridViewModelImpl(characterService: service)
    }

    func testLoadFirstCharactersPage_fetchesCharactersSuccessfully() async throws {
        // When
        await viewModel.loadFirstCharactersPage()
        
        // Then
        let characters = viewModel.characters
        XCTAssertFalse(characters.isEmpty, "Expected to load characters but got empty list")
        XCTAssertGreaterThan(characters.count, 0, "Expected more than 0 characters")
    }
}
