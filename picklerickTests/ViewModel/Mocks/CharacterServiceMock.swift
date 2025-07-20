//
//  CharacterServiceMock.swift
//  picklerickTests
//
//  Created by Miki on 16/7/25.
//

import Foundation
@testable import picklerick

class CharacterServiceMock : CharacterService {
    var fetchCharactersCalled = false
    var fetchCharactersResponse: [picklerick.Character] = []
 
    func fetchCharacters(page: Int, query: String?, filters: [String: String]) async throws -> [Character] {
        fetchCharactersCalled = true
        return fetchCharactersResponse
    }
}




