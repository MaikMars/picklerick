//
//  CharacterListViewModel.swift
//  picklerick
//
//  Created by Miki on 15/7/25.
//
import Foundation
import Combine

@MainActor
protocol CharactersGridViewModel: ObservableObject {
    func loadFirstCharactersPage() async throws
    func loadMoreIfNeeded(after character: Character) async
}

class CharactersGridViewModelImpl: CharactersGridViewModel {
    
    private let characterService: CharacterService
    private var currentPage = 1
    private var hasMorePages = true
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var isLoading = false
    @Published var characters: [Character] = []
    @Published var errorMessage: String? = nil
    @Published var query: String = ""
    
    @Published var searchType: String = "name" {
        didSet { Task {  await loadFirstCharactersPage() } }
    }
    @Published var appliedFilters: [String: String] = [:] {
        didSet { Task {  await loadFirstCharactersPage() } }
    }
        
    init(
        characterService: CharacterService = CharacterServiceImpl(),
        isLoading: Bool = false,
        characters: [Character] = []
    ) {
        self.characterService = characterService
        self.isLoading = isLoading
        self.characters = characters
        observeQueryChanges()
    }
    
    
    func loadFirstCharactersPage() async {
        resetState()
        await loadCharacters()
    }
    
    func loadMoreIfNeeded(after character: Character) async {
        guard let lastCharacter = characters.last, lastCharacter.id == character.id else { return }
        await loadCharacters()
    }
    
    internal func resetState() {
        currentPage = 1
        hasMorePages = true
        characters = []
        errorMessage = nil
    }
    
    private func observeQueryChanges() {
            $query
                .removeDuplicates()
                .debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
                .sink { [weak self] value in
                    Task {
                        await self?.loadFirstCharactersPage()
                    }
                }
                .store(in: &cancellables)
        }
    
    internal func loadCharacters() async {
        guard !isLoading, hasMorePages else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let newCharacters = try await characterService.fetchCharacters(
                page: currentPage,
                query: query,
                filters: appliedFilters
            )
            if newCharacters.isEmpty {
                hasMorePages = false
            } else {
                characters += newCharacters
                currentPage += 1
            }
        } catch {
            errorMessage = "Error cargando personajes: \(error.localizedDescription)"
            hasMorePages = false
        }
    }
}
