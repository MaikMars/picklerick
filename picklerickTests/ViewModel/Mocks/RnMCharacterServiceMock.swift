//
//  RnMCharacterServiceMock.swift
//  picklerickTests
//
//  Created by Miki on 16/7/25.
//

import Foundation
@testable import picklerick

class RnMCharacterServiceMock: RnMCharacterService {
    var fetchAllCharactersCalled = false
    var fetchAllCharactersResponse: [picklerick.Character] = []
    
    func fetchAllCharacters(page: Int) async throws -> [picklerick.Character] {
        fetchAllCharactersCalled = true
        return fetchAllCharactersResponse
    }
}
