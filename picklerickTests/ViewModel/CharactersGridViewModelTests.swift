//
//  CharacterListViewModelTests.swift
//  picklerickTests
//
//  Created by Miki on 16/7/25.
//

import XCTest
@testable import picklerick

@MainActor
final class CharactersGridViewModelTests: XCTestCase {
    
    var service: RnMCharacterServiceMock!
    var viewModel: CharactersGridViewModelImpl!

    override func setUp() {
        service = RnMCharacterServiceMock()
        service.fetchCharactersResponse = [
            Character(id: 1, name: "Rick Sanchez", status: "Alive", species: "Human", gender: "Male", imageURL: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
        ]
        viewModel = CharactersGridViewModelImpl(characterService: service)
    }
    
    func testLoadCharacters_callsService() async {
        //When
        await viewModel.loadCharacters()
        
        //Then
        XCTAssertTrue(service.fetchCharactersCalled)
    }

    func testLoadCharacters_responseSuccess() async {
        //When
        await viewModel.loadCharacters()
        
        //Then
        let character = viewModel.characters.first!
        XCTAssertEqual(viewModel.characters.count, 1)
        XCTAssertEqual(character.id, 1)
        XCTAssertEqual(character.name, "Rick Sanchez")
    }
    
    func testLoadCharacters_setsIsLoadingToFalse_onSuccess() async {
        //When
        await viewModel.loadCharacters()
        
        //Then
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testResetState_setsCharactersToEmpty() {
        //Given
        viewModel.characters = [.init(id: 1, name: "Rick Sanchez", status: "Alive", species: "Human", gender: "Male", imageURL: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")]
        
        //When
        viewModel.resetState()
        
        //Then
        XCTAssertTrue(viewModel.characters.isEmpty)
    }
}
