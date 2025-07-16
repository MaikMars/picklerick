//
//  CharacterListViewModel.swift
//  picklerick
//
//  Created by Miki on 15/7/25.
//

import Foundation


protocol CharactersGridViewModel: ObservableObject {
    func loadFirstCharactersPage() async throws
    func loadMoreIfNeeded(after character: Character) async
}

class CharactersGridViewModelImpl: CharactersGridViewModel {

    
    private let characterService: RnMCharacterService
    private var currentPage = 1
    private var hasMorePages = true
    @Published var isLoading = false
    @Published var characters: [Character]
    
    init(
        characterService: RnMCharacterService = RnMCharacterServiceImpl(),
        isLoading: Bool = false,
        characters: [Character] = [])
    {
        self.characterService = characterService
        self.isLoading = isLoading
        self.characters = characters
    }
    
    func loadFirstCharactersPage() async {
        resetState()
        do {
            try await loadCharacters()
        } catch {
            
        }
    }
    
    func loadMoreIfNeeded(after character: Character) async {
        guard let lastCharacter = characters.last else { return }
        if character.id == lastCharacter.id {
            do {
                try await loadCharacters()
            } catch {
                //
            }
        }
    }
    
    internal func resetState() {
        currentPage = 1
        hasMorePages = true
        characters = []
    }
    
    internal func loadCharacters() async throws {
           guard !isLoading, hasMorePages else { return }
           isLoading = true
           defer { isLoading = false }
           
           do {
               let newCharacters = try await characterService.fetchAllCharacters(page: currentPage)
               if newCharacters.isEmpty {
                   hasMorePages = false
               } else {
                   characters += newCharacters
                   currentPage += 1
               }
           } catch {
               // handlear errores
               hasMorePages = false
           }
       }
}


